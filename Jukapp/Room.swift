//
//  Room.swift
//  Jukapp
//
//  Created by Berk Caputcu on 2015-07-22.
//  Copyright (c) 2015 Berk Caputcu. All rights reserved.
//

import Foundation

class Room {
    var id : Int!
    var name : String!
    
    init(data: NSDictionary) {
        self.id = data["id"] as! Int
        self.name = getStringFromJSON(data, key: "name")
    }
    
    // Duplicated Code from Video
    func getStringFromJSON(data: NSDictionary, key: String) -> String {
        if let info = data[key] as? String {
            return info
        }
        
        return ""
    }
}