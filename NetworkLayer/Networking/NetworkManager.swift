//
//  NetworkManager.swift
//
//  Created by Asmaa Tarek on 4/7/21.
//  Copyright © 2021 Asmaa Tarek. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

//MARK: - NetworkManager

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData<M: Codable>(request: NetworkAPI, mappingClass: M.Type) -> Promise<M> {
        
        let method = request.method
        let headers = Alamofire.HTTPHeaders(request.headers ?? [:])
        let parameters = buildParameters(task: request.task)
        let url = request.baseURL + request.path
        
        return Promise<M> { seal in
            
            if Connectivity.isConnectedToInternet {
                AF.request(url, method: method, parameters: parameters.0, encoding: parameters.1, headers: headers).responseDecodable { (response: DataResponse<M, AFError>) in
                    switch response.result {
                    case .success(let value):
                        seal.fulfill(value)
                    case.failure(let error):
                        print(error.localizedDescription.description)
                        guard let statusCode = response.response?.statusCode else {
                            seal.reject(HTTPErrors.undefined)
                            return
                        }
                        
                        switch statusCode {
                        case 100..<200:
                            seal.reject(HTTPErrors.informational)
                            
                        case 300..<400:
                            seal.reject(HTTPErrors.redirection)
                            
                        case 400..<500:
                            seal.reject(HTTPErrors.clientError)
                            
                        case 500..<600:
                            seal.reject(HTTPErrors.serverError)
                            
                        default:
                            seal.reject(HTTPErrors.undefined)
                        }
                    }
                }
            } else {
                seal.reject(HTTPErrors.noInternet)
            }
        }
    }
    
    private func buildParameters(task: Task) -> ([String:Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:] , URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters,encoding)
        }
    }
}

