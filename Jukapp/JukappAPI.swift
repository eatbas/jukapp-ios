//
//  JukappAPI.swift
//  Jukapp
//
//  Created by Berk Caputcu on 2015-07-20.
//  Copyright (c) 2015 Berk Caputcu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class JukappAPI {
    
    let jukappUrl = "http://5d4eb299.ngrok.com"
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func joinRoom(roomId: Int, completion: ((Bool) -> Void)!) {
        
        Alamofire.request(.GET, "\(jukappUrl)/rooms/\(roomId)/join.json")
            .responseJSON { request, response, data, error in
                let successfullResponse = response?.statusCode == 200
                
                if successfullResponse {
                    self.defaults.setInteger(roomId, forKey: "currentRoom")
                }

                completion(successfullResponse)
        }
    }
    
    func loadRooms(completion: (([Room]) -> Void)!) {
        
        Alamofire.request(.GET, "\(jukappUrl)/rooms.json")
            .responseJSON { request, response, data, error in
                var rooms = [Room]()
            
                if let roomsJson = data as? NSArray {
                    for roomJson in roomsJson {
                        let room = Room(data: roomJson as! NSDictionary)
                        rooms.append(room)
                    }
                }
                
                completion(rooms)
        }
    }
    
    func loadFavorites(completion: (([Video]) -> Void)!) {

        Alamofire.request(.GET, "\(jukappUrl)/favorites.json")
            .responseJSON { request, response, data, error in
                var favoriteVideos = [Video]()
                
                if let favoriteVideosJson = JSON(data!).array {
                    for favoriteVideoJson in favoriteVideosJson {
                        let favoriteVideo = Video(data: favoriteVideoJson)
                        favoriteVideos.append(favoriteVideo)
                    }
                }
                
                completion(favoriteVideos)
        }
    }
    
    func addToQueue(youtubeId: String, withTitle: String) {
        
        let parameters = [
            "youtube_id": youtubeId,
            "title": withTitle
        ]
        
        Alamofire.request(.POST, "\(jukappUrl)/queue", parameters: parameters)
    }
    
    func searchVideos(searchText: String, completion: (([Video]) -> Void)!) {
        let parameters = [ "query": searchText ]
        
        Alamofire.request(.GET, "\(jukappUrl)/search", parameters: parameters)
            .responseJSON { request, response, data, error in
                var searchResults = [Video]()
                
                if let searchResultsJson = JSON(data!)["videos"].array {
                    for searchResultJson in searchResultsJson {
                        let searchResult = Video(data: searchResultJson)
                        searchResults.append(searchResult)
                    }
                }
                
                completion(searchResults)
        }
    }
}