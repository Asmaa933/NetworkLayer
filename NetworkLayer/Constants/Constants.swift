//
//  Constants.swift
//  NetworkLayer
//
//  Created by Asmaa Tarek on 05/05/2021.
//

import Foundation

enum Constants {
   static let baseURL = "https://jsonplaceholder.typicode.com/"
    static let posts = "posts"
    
    enum ConnectionType {
        case wifi
        case ethernet
        case cellular
        case unknown
    }
}
