//
//  Video.swift
//  Jukapp
//
//  Created by Berk Caputcu on 2015-07-20.
//  Copyright (c) 2015 Berk Caputcu. All rights reserved.
//

import Foundation

class Video {
    var id : Int!
    var title : String!
    var youtube_id : String!
    
    init(data: NSDictionary) {
        self.id = data["id"] as! Int
        self.title = getStringFromJSON(data, key: "title")
        self.youtube_id = getStringFromJSON(data, key: "youtube_id")
    }
    
    func getStringFromJSON(data: NSDictionary, key: String) -> String {
        if let info = data[key] as? String {
            return info
        }
        
        return ""
    }
}