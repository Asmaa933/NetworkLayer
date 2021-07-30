//
//  NetworkAPI.swift
//  NetworkLayer
//
//  Created by Asmaa Tarek on 05/05/2021.
//

import Foundation
import Alamofire

enum NetworkAPI {
    case getPosts
}

extension NetworkAPI: Requestable {
    
    var baseURL: String {
        return Constants.baseURL
    }
    
    var path: String {
        switch self {
        case .getPosts:
            return Constants.posts
        }
    }
    
    var method: HTTPMethod {
        switch self {
        
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPosts:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        
        default:
            return [:]
            
        }
    }
}
