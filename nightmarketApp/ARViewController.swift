//
//  ARViewController.swift
//  fuck
//
//  Created by vicky on 2020/9/29.
//  Copyright © 2020 Ariel. All rights reserved.
//

import UIKit
import ARKit
import Vision
import AVFoundation
import CoreMedia
import VideoToolbox

class ARViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var label: UILabel!
    //yolov4
    let labelHeight:CGFloat = 50.0
   
    let yolo = YOLO()
    
    var videoCapture: VideoCapture!
    var request: VNCoreMLRequest!
    var startTimes: [CFTimeInterval] = []
    
    var boundingBoxes = [BoundingBox]()
    var colors: [UIColor] = []
    
    let ciContext = CIContext()
    var resizedPixelBuffer: CVPixelBuffer?
    
    var framesDone = 0
    var frameCapturingStartTime = CACurrentMediaTime()
    let semaphore = DispatchSemaphore(value: 2)
    
    
    let timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    /*let  videoPreview: UIView = {
        let view = UIView()
        return view
    }()*/
    
    
    let fadeDuration: TimeInterval = 0.3
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 0.5
    
    lazy var fadeAndSpinAction: SCNAction = {
        //CGFloat.pi * 360 / 180
        return .sequence([
            .fadeIn(duration: fadeDuration),
            .rotateBy(x: 0, y: 0, z: 0, duration: rotateDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
            ])
    }()
    
    lazy var fadeAction: SCNAction = {
        return .sequence([
            .fadeOpacity(by: 0.8, duration: fadeDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
            ])
    }()
    lazy var treeNode: SCNNode = {
        guard let scene = SCNScene(named: "tree.scn"),
            let node = scene.rootNode.childNode(withName: "tree", recursively: false) else { return SCNNode() }
        let scaleFactor = 0.005
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles.x = -.pi / 2
        return node
    }()
    lazy var bookNode: SCNNode = {
        guard let scene = SCNScene(named: "book.scn"),
            let node = scene.rootNode.childNode(withName: "book", recursively: false) else { return SCNNode() }
        let scaleFactor  = 0.025
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        //node.eulerAngles.x += -.pi / 2
        return node
    }()
    
    lazy var mountainNode: SCNNode = {
        guard let scene = SCNScene(named: "little.scn"),
            let node = scene.rootNode.childNode(withName: "little", recursively: false) else { return SCNNode() }
        let scaleFactor  = 0.1
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles.x += -.pi / 2
        return node
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        configureLighting()
        label.text = "Move camera around to detect signboard"
        //yolov4
        timeLabel.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - self.labelHeight, width: UIScreen.main.bounds.size.width, height: self.labelHeight)
        //sceneView.frame = self.view.frame
    
        view.addSubview(timeLabel)
        //view.addSubview(sceneView)
    
        timeLabel.text = ""
    
        setUpBoundingBoxes()
        setUpCoreImage()
        setUpCamera()
    
        frameCapturingStartTime = CACurrentMediaTime()
    }
    
    func setUpBoundingBoxes() {
        for _ in 0..<YOLO.maxBoundingBoxes {
            boundingBoxes.append(BoundingBox())
        }
        
        // Make colors for the bounding boxes. There is one color for each class,
        // 20 classes in total.
        for r: CGFloat in [0.1,0.2, 0.3,0.4,0.5, 0.6,0.7, 0.8,0.9, 1.0] {
            for g: CGFloat in [0.3,0.5, 0.7,0.9] {
                for b: CGFloat in [0.4,0.6 ,0.8] {
                    let color = UIColor(red: r, green: g, blue: b, alpha: 1)
                    colors.append(color)
                }
            }
        }
    }
    func setUpCoreImage() {
        let status = CVPixelBufferCreate(nil, YOLO.inputWidth, YOLO.inputHeight,
                                         kCVPixelFormatType_32BGRA, nil,
                                         &resizedPixelBuffer)
        if status != kCVReturnSuccess {
            print("Error: could not create resized pixel buffer", status)
        }
    }
    
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 50
        weak var welf = self
     //log問題
        videoCapture.setUp(sessionPreset: AVCaptureSession.Preset.vga640x480) { success in
            if success {
                // Add the video preview into the UI.
                if let previewLayer = welf?.videoCapture.previewLayer {
                    welf?.sceneView.layer.addSublayer(previewLayer)
                    welf?.resizePreviewLayer()
                }

                
                // Add the bounding box layers to the UI, on top of the video preview.
                DispatchQueue.main.async {
                    guard let  boxes = welf?.boundingBoxes,let videoLayer  = welf?.sceneView.layer else {return}
                    for box in boxes {
                        box.addToLayer(videoLayer)
                    }
                    welf?.semaphore.signal()
                }
                
                
                // Once everything is set up, we can start capturing live video.
                welf?.videoCapture.start()
                
                
                //     yolo.buffer(from: image)
                //        self.predict(pixelBuffer: self.yolo.buffer(from: image)!)
                
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resizePreviewLayer()
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = sceneView.bounds
    }
    
    func predict(pixelBuffer: CVPixelBuffer) {
        // Measure how long it takes to predict a single video frame.
        let startTime = CACurrentMediaTime()
        
        // Resize the input with Core Image to 416x416.
        guard let resizedPixelBuffer = resizedPixelBuffer else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let sx = CGFloat(YOLO.inputWidth) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let sy = CGFloat(YOLO.inputHeight) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
        let scaledImage = ciImage.transformed(by: scaleTransform)
        ciContext.render(scaledImage, to: resizedPixelBuffer)
        
        // This is an alternative way to resize the image (using vImage):
        //if let resizedPixelBuffer = resizePixelBuffer(pixelBuffer,
        //                                              width: YOLO.inputWidth,
        //                                              height: YOLO.inputHeight)
        
        // Resize the input to 416x416 and give it to our model.
        if let boundingBoxes = try? yolo.predict(image: resizedPixelBuffer) {
            let elapsed = CACurrentMediaTime() - startTime
            showOnMainThread(boundingBoxes, elapsed)
        }
    }
    
    
    func showOnMainThread(_ boundingBoxes: [YOLO.Prediction], _ elapsed: CFTimeInterval) {
        weak var welf = self
        
        DispatchQueue.main.async {
            // For debugging, to make sure the resized CVPixelBuffer is correct.
            //var debugImage: CGImage?
            //VTCreateCGImageFromCVPixelBuffer(resizedPixelBuffer, nil, &debugImage)
            //self.debugImageView.image = UIImage(cgImage: debugImage!)
            
            welf?.show(predictions: boundingBoxes)
            
            guard  let fps = welf?.measureFPS() else{return}
            welf?.timeLabel.text = String(format: "Elapsed %.5f seconds - %.2f FPS", elapsed, fps)
            
            welf?.semaphore.signal()
        }
    }

    func show(predictions: [YOLO.Prediction]) -> String{
        let name:String?
        for i in 0..<boundingBoxes.count {
            if i < predictions.count {
                let prediction = predictions[i]
                
                // The predicted bounding box is in the coordinate space of the input
                // image, which is a square image of 416x416 pixels. We want to show it
                // on the video preview, which is as wide as the screen and has a 4:3
                // aspect ratio. The video preview also may be letterboxed at the top
                // and bottom.
                let width = view.bounds.width
                let height = width * 4 / 3
                let scaleX = width / CGFloat(YOLO.inputWidth)
                let scaleY = height / CGFloat(YOLO.inputHeight)
                let top = (view.bounds.height - height) / 2
                
                // Translate and scale the rectangle to our own coordinate system.
                var rect = prediction.rect
                rect.origin.x *= scaleX
                rect.origin.y *= scaleY
                rect.origin.y += top
                rect.size.width *= scaleX
                rect.size.height *= scaleY
                
                // Show the bounding box.
                let label = String(format: "%@ %.1f", labels[prediction.classIndex], prediction.score)
                let color = colors[prediction.classIndex]
                boundingBoxes[i].show(frame: rect, label: label, color: color)
                name = labels[prediction.classIndex]
            } else {
                boundingBoxes[i].hide()
            }
        }
        return name!
    }
    
    func measureFPS() -> Double {
        // Measure how many frames were actually delivered per second.
        framesDone += 1
        let frameCapturingElapsed = CACurrentMediaTime() - frameCapturingStartTime
        let currentFPSDelivered = Double(framesDone) / frameCapturingElapsed
        if frameCapturingElapsed > 1 {
            framesDone = 0
            frameCapturingStartTime = CACurrentMediaTime()
        }
        return currentFPSDelivered
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetTrackingConfiguration()
    }
    
    @IBAction func resetButtonDidTiuch(_ sender: Any) {
        resetTrackingConfiguration()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    //detecting
    func resetTrackingConfiguration() {
      // guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        let configuration = ARWorldTrackingConfiguration()
        //configuration.detectionImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
        label.text = "Move camera around to detect images"
    }
}
//after detect
extension ARViewController: ARSCNViewDelegate {
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    DispatchQueue.main.async {
    guard let imageAnchor = anchor as? ARImageAnchor ,
    let imageName = imageAnchor.referenceImage.name else { return }
           
    //let plane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
    //   let planeNode = SCNNode(geometry: plane)
     //  planeNode.opacity = 0.20
     //  planeNode.eulerAngles.x = -.pi / 2
       
      // planeNode.runAction(imageHighlightAction)
    
        //node.addChildNode(planeNode)
    let overlayNode = self.getNode(withImageName: imageName)
    overlayNode.opacity = 0
    overlayNode.position.y = 0.2
    overlayNode.runAction(self.fadeAndSpinAction)

    node.addChildNode(overlayNode)
        
            self.label.text = "Image detected: \"\(imageName)\""
        }
    
       // guard let imageAnchor = anchor as? ARImageAnchor else { return }
        //let imageName = imageAnchor.referenceImage.name
        //self.label.text = "\(imageName)"
        //let store = self.label.text
          
       // let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let pagemenu = storyboard.instantiateViewController(withIdentifier: "pagemenu")  as! MenuTableViewController

        //pagemenu.receive1 = store!
        //self.present(pagemenu, animated: true, completion: nil)
        
       //   if (store?.caseInsensitiveCompare("chicken") == .orderedSame){
       //       let next=self.storyboard?.instantiateViewController(withIdentifier:"pagemenu")
         //     self.present(next!, animated: true, completion: nil)
          //}
        //self.resetTrackingConfiguration()
  }
   /* func getPlaneNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        let node = SCNNode(geometry: plane)
        return node
    }*/
    
    func getNode(withImageName name: String) -> SCNNode {
        var node = SCNNode()
        switch name {
        case "2":
            node = bookNode
        case "image27":
            node = bookNode
        case "image28":
            node = treeNode
        default:
            break
        }
        return node
    }
}

extension ARViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        // For debugging.
        //    predict(image: UIImage(named: "bridge00508")!); return
        //    semaphore.wait()
        
        weak var welf = self
        if let pixelBuffer = pixelBuffer {
            // For better throughput, perform the prediction on a background queue
            // instead of on the VideoCapture queue. We use the semaphore to block
            // the capture queue and drop frames when Core ML can't keep up.
            DispatchQueue.global().async {
                welf?.predict(pixelBuffer: pixelBuffer)
                //        self.predictUsingVision(pixelBuffer: pixelBuffer)
            }
        }
    }
}

