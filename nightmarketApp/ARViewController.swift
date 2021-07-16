//
//  ARViewController.swift
//  fuck
//
//  Created by vicky on 2020/9/29.
//  Copyright © 2020 Ariel. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var label: UILabel!
    
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
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
        //label.text = "Move camera around to detect images"
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
    func getPlaneNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        let node = SCNNode(geometry: plane)
        return node
    }
    
    func getNode(withImageName name: String) -> SCNNode {
        var node = SCNNode()
        switch name {
        case "Book":
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
