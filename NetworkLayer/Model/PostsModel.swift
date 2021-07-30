//
//  PostsModel.swift
//  NetworkLayer
//
//  Created by Asmaa Tarek on 05/05/2021.
//

import Foundation

struct Post: Codable {
    var userID, id: Int?
    var title, body: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

