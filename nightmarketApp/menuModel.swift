//
//  menuModel.swift
//  fuck
//
//  Created by 陳昱維 on 2021/5/27.
//  Copyright © 2021 Ariel. All rights reserved.
//

import UIKit

protocol  menuModelDelegate {
    func itemsDownloaded(menu:[menu])
}

class menuModel: NSObject {
    var delegate:menuModelDelegate?
    
    func getItems(){
        
        let serviceUrl = "http://localhost:8888/menu.php"
        
        let url = URL(string: serviceUrl)
        
        if let url = url{
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url,completionHandler:
                { (data, response, error) in
                    
                if error == nil{//succeeded
                    self.parseJson(data!)
                }
                else{//error
                    
                }
            })
            task.resume()
        }
    }
    func parseJson(_ data:Data){
        var locArray = [menu]()
        
        do{
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            
            for jsonResult in jsonArray{
                
                let jsonDict = jsonResult as! [String:String]
                let loc = menu(ID: jsonDict["ID"]!, store_ID: jsonDict["store_ID"]!,spec: jsonDict["class"]!,
                               name: jsonDict["name"]!,price: jsonDict["price"]!)
                
                locArray.append(loc)
            }
            delegate?.itemsDownloaded(menu:locArray)
        }
        catch{
            print("there was an error!")
        }
        
    }

}
