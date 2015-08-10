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
    static var OAuthToken: String?
    static var CurrentRoomId: Int?
    
    case JoinRoom(Int)
    case ListRooms
    case QueueVideo([String: AnyObject])
    case SearchVideos([String: AnyObject])
    case SignIn([String: AnyObject])
    
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
        }
    }
    
    var path: String {
        switch self {
        case .JoinRoom(let roomId):
            return "/rooms/\(roomId)/join.json"
        case .ListRooms:
            return "/rooms.json"
        case .QueueVideo:
            return "/queue"
        case .SearchVideos:
            return "/search"
        case .SignIn:
            return "/users/sign_in.json"
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        if let token = Router.OAuthToken {
            mutableURLRequest.setValue("\(token)", forHTTPHeaderField: "Authorization")
        }

        if let roomId = Router.CurrentRoomId {
            mutableURLRequest.setValue("\(roomId)", forHTTPHeaderField: "X-Room-ID")
        }
        
        switch self {
        case .ListRooms:
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: nil).0
        case .QueueVideo(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .SearchVideos(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .SignIn(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}
    