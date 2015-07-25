//
//  Video.swift
//  Jukapp
//
//  Created by Berk Caputcu on 2015-07-20.
//  Copyright (c) 2015 Berk Caputcu. All rights reserved.
//

import Foundation
import SwiftyJSON

class Video {
    var id : Int!
    var title : String!
    var youtube_id : String!
    
    init(data: JSON) {
        self.id = data["id"].int
        self.title = data["title"].string
        self.youtube_id = data["youtube_id"].string
    }
}