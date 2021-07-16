//
//  StoreTableViewController.swift
//  fuck
//
//  Created by vicky on 2020/10/3.
//  Copyright © 2020 Ariel. All rights reserved.
//

import UIKit

class CommendTableViewController: UITableViewController,HomeModelProtocol {

    var receive = 0
    @IBOutlet var listTableView: UITableView!
    var feedItems: NSArray = NSArray()
        var selectedLocation : CommentModel = CommentModel()
     func itemsDownloaded(items: NSArray) {
         feedItems = items
         self.listTableView.reloadData()
     }
     override func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return feedItems.count
     }
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
         let item: CommentModel = feedItems[indexPath.row] as! CommentModel
         cell.textLabel?.text = "評論：" + item.tit!
             return cell
     }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        if (receive == 0){
            let homemenu1Model = HomeComment1Model()
            homemenu1Model.delegate = self
            homemenu1Model.downloadItems()
        }else if(receive == 1){
            let homemenu2Model = HomeMenu2Model()
            homemenu2Model.delegate = self
            homemenu2Model.downloadItems()
        }else if(receive == 2){
            let homemenu3Model = HomeMenu3Model()
            homemenu3Model.delegate = self
            homemenu3Model.downloadItems()
        }else if(receive == 3){
            let homemenu4Model = HomeMenu4Model()
            homemenu4Model.delegate = self
            homemenu4Model.downloadItems()
        }else if(receive == 4){
            let homemenu5Model = HomeMenu5Model()
            homemenu5Model.delegate = self
            homemenu5Model.downloadItems()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//
//  HomeModel.swift
//  fuck
//
//  Created by Ariel on 2020/9/28.
//  Copyright © 2020 Ariel. All rights reserved.
//
