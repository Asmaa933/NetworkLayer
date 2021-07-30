//
//  TargetType.swift
//
//  Created by Asmaa Tarek on 4/7/21.
//  Copyright © 2020 Asmaa Tarek. All rights reserved.
//

import Foundation
import Alamofire

enum Task {
    case requestPlain
    case requestParameters(parameters: [String: Any],encoding: ParameterEncoding)
}

protocol Requestable:  URLRequestConvertible{
    var baseURL: String {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var task: Task {get}
    var headers: [String:String]? {get}
}

extension Requestable {
    var baseURL: String {
        return Constants.baseURL
    }
    var path: String {
        return ""
    }
    var method: HTTPMethod {
        return .get
    }
    var task: Task {
        return .requestPlain
    }
    var headers: [String:String]? {
        return [:]
    }
    
    func asURLRequest() throws -> URLRequest {
        
    }
    
    
}

