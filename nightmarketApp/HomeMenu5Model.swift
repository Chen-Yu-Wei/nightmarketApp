//
//  HomeModel.swift
//  fuck
//
//  Created by Ariel on 2020/9/28.
//  Copyright © 2020 Ariel. All rights reserved.
//

import Foundation




class HomeMenu5Model: NSObject, URLSessionDataDelegate {
    //properties
    
    weak var delegate: HomeModelProtocol!
    
    var urlPath: String = "http://163.21.245.137/~u10616001/menu5.php" //this will be changed to the path where service.php lives
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        let menus = NSMutableArray()
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let menu = Menu1Model()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let name = jsonElement["Name"] as? String,
                let price = jsonElement["Price"] as? String
            {
                
                menu.name = name
                menu.price = price
                
            }
            
            menus.add(menu)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: menus)
            
        })
    }

    
    func downloadItems() {
            
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
            
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
                
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                self.parseJSON(data!)
            }
                
        }
        
        task.resume()
    }
}

