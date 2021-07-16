//
//  LocationModel.swift
//  fuck
//
//  Created by Ariel on 2020/9/28.
//  Copyright © 2020 Ariel. All rights reserved.
//
import Foundation

class CommentModel: NSObject {
    
    //properties
    
    var tit: String?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(tit: String) {
        
        self.tit = tit
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "\(tit)"
        
    }
    
    
}
