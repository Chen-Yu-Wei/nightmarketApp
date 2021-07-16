//
//  StoreTableViewController.swift
//  fuck
//
//  Created by 陳昱維 on 2021/4/27.
//  Copyright © 2021 Ariel. All rights reserved.
//
import Foundation
import UIKit

class StoreTableViewController: UITableViewController ,storeModelDelegate{
    
    var storemodel = storeModel()
    var stores = [store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storemodel.getItems()
        storemodel.delegate = self
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stores.count
    }
    func itemsDownloaded(store: [store]) {
        self.stores = store
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = stores[indexPath.row].name_id
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStoreDetail"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationController = segue.destination as! TViewDetailViewController
                destinationController.storeID = stores[indexPath.row].number_id
            }
        }
    }
}
