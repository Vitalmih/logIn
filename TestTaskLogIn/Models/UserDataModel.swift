//
//  UserDataModel.swift
//  TestTaskLogIn
//
//  Created by Виталий on 21.01.2021.
//

import Foundation


struct UserDataModel: Codable {
    
    let token: String
    
    private enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
}

