//
//  storeModel.swift
//  fuck
//
//  Created by 陳昱維 on 2021/4/28.
//  Copyright © 2021 Ariel. All rights reserved.
//

import UIKit

protocol  storeModelDelegate {
    func itemsDownloaded(store:[store])
}
class storeModel: NSObject {
    var delegate:storeModelDelegate?
    
    func getItems(){
        
        let serviceUrl = "http://localhost:8888/store.php"
        
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
        var locArray = [store]()
        
        do{
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            
            for jsonResult in jsonArray{
                
                let jsonDict = jsonResult as! [String:String]
                let loc = store(number_id: jsonDict["number_id"]!, name_id: jsonDict["name_id"]!)
                
                locArray.append(loc)
            }
            delegate?.itemsDownloaded(store:locArray)
        }
        catch{
            print("there was an error!")
        }
        
    }
}
