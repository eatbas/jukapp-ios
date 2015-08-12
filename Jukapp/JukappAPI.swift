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
import Locksmith

class JukappAPI {

    let defaults = NSUserDefaults.standardUserDefaults()
    
    init() {
        if (Router.AuthToken == nil) {
            if let user = Locksmith.loadDataForUserAccount("JukappAccount").0 {
                Router.AuthToken = user["AuthToken"] as? String
                Router.Username = user["Username"] as? String
            }
        }
    }
    
    func joinRoom(roomId: Int, completion: ((Bool) -> Void)!) {
        Alamofire.request(Router.JoinRoom(roomId))
            .responseJSON { request, response, data, error in
                let joinSuccess = response?.statusCode == 200

                if (joinSuccess) {
                    Router.CurrentRoomId = roomId
                    self.defaults.setInteger(Router.CurrentRoomId, forKey: "currentRoom")
                }

                completion(joinSuccess)
        }
    }
    
    func leaveRoom() {
        Router.CurrentRoomId = 0
        defaults.removeObjectForKey("currentRoom")
    }
    
    func signIn(username: String, password: String, completion: ((Bool) -> Void)!) {
        Alamofire.request(Router.SignIn(["user": ["username": username, "password": password]]))
            .responseJSON { request, response, data, error in
                let loginSuccess = response?.statusCode == 201
                
                if loginSuccess  {
                    Router.AuthToken = JSON(data!)["authentication_token"].string
                    Router.Username = username

                    Locksmith.saveData(["AuthToken": Router.AuthToken!, "Username": Router.Username!], forUserAccount: "JukappAccount")
                }
                
                completion(loginSuccess)
            }
    }
    
    func loadRooms(completion: (([Room]) -> Void)!) {
        
        Alamofire.request(Router.ListRooms)
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

        Alamofire.request(Router.ListFavorites)
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

        Alamofire.request(Router.QueueVideo(parameters))
    }
    
    func searchVideos(searchText: String, completion: (([Video]) -> Void)!) {
        let parameters = [ "query": searchText ]

        Alamofire.request(Router.SearchVideos(parameters))
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