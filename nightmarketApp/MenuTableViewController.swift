//
//  StoreTableViewController.swift
//  fuck
//
//  Created by vicky on 2020/10/3.
//  Copyright © 2020 Ariel. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController,menuModelDelegate {
    var menumodel = menuModel()
    var menus = [menu]()
    var menusname = ["山內雞肉飯","蔥燒肉飯","腱肉飯","咖哩飯","雞腿飯","金針湯","下水湯","桂竹筍湯","香菇湯","山內雞肉","滷豬腱肉","雞腿肉","桂竹筍"]
    var menusprice = ["90","80","80","70","80","30","30","30","35","60","60","60","60"]
    var storeID = ""
    
    @IBOutlet var listTableView: UITableView!
    func itemsDownloaded(menu: [menu]) {
        self.menus = menu
        tableView.reloadData()
    }
     override func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return menus.count
        return menusname.count
     }
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! MenuTableViewCell
         //let item: Menu1Model = feedItems[indexPath.row] as! Menu1Model
        //if menus[indexPath.row].store_ID == storeID{
            //cell.nameLabel.text = menus[indexPath.row].name
            //cell.priceLabel.text = "$" +  menus[indexPath.row].price
            cell.nameLabel.text = menusname[indexPath.row]
            cell.priceLabel.text = "$" +  menusprice[indexPath.row]
        
        //}
             return cell
     }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        //menumodel.getItems()
        //menumodel.delegate = self
        
    }
    
}
//
//  HomeModel.swift
//  fuck
//
//  Created by Ariel on 2020/9/28.
//  Copyright © 2020 Ariel. All rights reserved.
//
