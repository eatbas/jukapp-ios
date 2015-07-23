//
//  JukappAPI.swift
//  Jukapp
//
//  Created by Berk Caputcu on 2015-07-20.
//  Copyright (c) 2015 Berk Caputcu. All rights reserved.
//

import Foundation
import Alamofire

class JukappAPI {
    
    let jukappUrl = "http://5d4eb299.ngrok.com"
    
    func joinRoom(roomId: Int) {
        Alamofire.request(.GET, "\(jukappUrl)/rooms/\(roomId)/join.json")
            .responseJSON { request, response, data, error in
                return response?.statusCode == 200
        }
    }
    
    func loadRooms(completion: (([Room]) -> Void)!) {
        var roomsUrlString = "\(jukappUrl)/rooms.json"
        
        let session = NSURLSession.sharedSession()
        let roomsUrl = NSURL(string: roomsUrlString)
        
        var task = session.dataTaskWithURL(roomsUrl!) {
            (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                var error : NSError?
                
                var roomsData = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &error) as! NSArray
                
                var rooms = [Room]()
                for room in roomsData {
                    let room = Room(data: room as! NSDictionary)
                    rooms.append(room)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(rooms)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func loadFavorites(completion: (([Video]) -> Void)!) {
        
        var favoritesUrlString = "\(jukappUrl)/favorites.json"
        
        let session = NSURLSession.sharedSession()
        let favoritesUrl = NSURL(string: favoritesUrlString)
        
        var task = session.dataTaskWithURL(favoritesUrl!) {
            (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                var error : NSError?
                
                var videosData = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &error) as! NSArray
                
                var videos = [Video]()
                for video in videosData {
                    let video = Video(data: video as! NSDictionary)
                    videos.append(video)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(videos)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func addToQueue(youtubeId: String, withTitle: String) {
        var url = NSURL(string: "\(jukappUrl)/queue")
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        var bodyData = "youtube_id=\(youtubeId)&title=\(withTitle)"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        
        var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        
        connection?.start()
    }
}