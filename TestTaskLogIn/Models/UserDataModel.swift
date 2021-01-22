//
//  UserDataModel.swift
//  TestTaskLogIn
//
//  Created by Виталий on 21.01.2021.
//

import Foundation


struct UserDataModel: Codable {
    
    let token: String
    let user: User
    
    private enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case user
    }
}

struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case id
        case email
    }
}
