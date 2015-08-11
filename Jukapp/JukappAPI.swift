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
    
    let jukappUrl = "http://jukapp-api.herokuapp.com"
    
    func joinRoom(roomId: Int, completion: ((Bool) -> Void)!) {
        Alamofire.request(Router.JoinRoom(roomId))
            .responseJSON { request, response, data, error in
                completion(response?.statusCode == 200)
        }
    }
    
    func signIn(username: String, password: String, completion: ((String) -> Void)!) {
        Alamofire.request(Router.SignIn(["user[username]": username, "user[password]": password]))
            .responseJSON { request, response, data, error in
                
                if var auth_token = JSON(data!)["authentication_token"].string {
                    completion(auth_token)
                }
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