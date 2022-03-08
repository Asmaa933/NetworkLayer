//
//  NetworkManager.swift
//
//  Created by Asmaa Tarek on 4/7/21.
//  Copyright © 2021 Asmaa Tarek. All rights reserved.
//

import Foundation
import Alamofire

//MARK: - NetworkManager

typealias NetworkResponse<T> = (Result<T, Error>) -> Void

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(request: Requestable, mappingClass: T.Type, completion: NetworkResponse<T>?)
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    
    func fetchData<T: Decodable>(request: Requestable,
                                 mappingClass: T.Type,
                                 completion: NetworkResponse<T>?) {
        getRequestData(request: request)
            .validate(statusCode: 200...300)
            .responseDecodable { [weak self] (response: DataResponse<T, AFError>) in
                guard let self = self else { return }
                let result = self.handleResponse(response: response,
                                                 mappingClass: mappingClass)
                switch result {
                case .success(let decodedObject):
                    completion?(.success(decodedObject))
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    completion?(.failure(error))
                }
            }
    }
}

private extension NetworkManager {
    
    func getRequestData(request: Requestable) -> DataRequest {
        let parameters = buildParameters(task: request.task)
        let requestData = AF.request(request.baseURL + request.path,
                                     method: request.method,
                                     parameters: parameters.0,
                                     encoding: parameters.1,
                                     headers: Alamofire.HTTPHeaders(request.headers ?? [:]))
        
        return requestData
    }
    
    private func buildParameters(task: Task) -> ([String:Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:] , URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters,encoding)
        }
    }
    
    func handleResponse<T: Decodable> (response: DataResponse<T, AFError>, mappingClass: T.Type) -> Result<T, Error> {
        guard let jsonResponse = response.data else {
            return .failure(ErrorHandler.generalError)
        }
        switch response.result {
        case .success:
            do {
                let decodedObj = try JSONDecoder().decode(T.self, from: jsonResponse)
                return .success(decodedObj)
            } catch (let error) {
                debugPrint("Error in decoding ** \n \(error.localizedDescription)")
                return .failure(ErrorHandler.generalError)
            }
            
        case .failure(let error):
            debugPrint(error.localizedDescription)
            do {
                let errorModel = try JSONDecoder().decode(ErrorModel.self, from: jsonResponse)
                return .failure(ErrorHandler.custom(errorModel.message))
            } catch {
                debugPrint(error.localizedDescription)
                return .failure(error)
            }
        }
    }
}

