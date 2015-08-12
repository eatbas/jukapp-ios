//
//  Router.swift
//  
//
//  Created by Berk Caputcu on 2015-08-06.
//
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "http://jukapp-api.herokuapp.com" // "http://6b433d4.ngrok.com" //
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    static var AuthToken: String?
    static var Username: String?
    static var CurrentRoomId = defaults.integerForKey("currentRoom")

    case JoinRoom(Int)
    case ListRooms
    case QueueVideo([String: AnyObject])
    case SearchVideos([String: AnyObject])
    case SignIn([String: AnyObject])
    case ListFavorites
    
    var method: Alamofire.Method {
        switch self {
        case .JoinRoom:
            return .GET
        case .ListRooms:
            return .GET
        case .QueueVideo:
            return .POST
        case .SearchVideos:
            return .GET
        case .SignIn:
            return .POST
        case .ListFavorites:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .JoinRoom(let roomId):
            return "/rooms/\(roomId)/join"
        case .ListRooms:
            return "/rooms"
        case .QueueVideo:
            return "/queue"
        case .SearchVideos:
            return "/search"
        case .SignIn:
            return "/users/sign_in"
        case .ListFavorites:
            return "/favorites"
        }
    }

    // MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = Router.AuthToken, let username = Router.Username {
            mutableURLRequest.setValue(token, forHTTPHeaderField: "X-AuthToken")
            mutableURLRequest.setValue(username, forHTTPHeaderField: "X-Username")
        }

        if Router.CurrentRoomId > 0 {
            mutableURLRequest.setValue(String(Router.CurrentRoomId), forHTTPHeaderField: "X-Room-ID")
        }
        
        switch self {
        case .QueueVideo(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .SearchVideos(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .SignIn(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}
    