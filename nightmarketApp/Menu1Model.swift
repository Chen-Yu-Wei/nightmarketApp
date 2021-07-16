//
//  LocationModel.swift
//  fuck
//
//  Created by Ariel on 2020/9/28.
//  Copyright © 2020 Ariel. All rights reserved.
//
import Foundation

class Menu1Model: NSObject {
    
    //properties
    
    var name: String?
    var price: String?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(name: String, price: String) {
        
        self.name = name
        self.price = price
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Name: \(name), Price: \(price)"
        
    }
    
    
}
