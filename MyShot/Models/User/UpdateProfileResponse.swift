//
//  UpdateProfileResponse.swift
//  MyShot
//
//  Created by Administrador on 16/06/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import Foundation
struct UpdateProfileResponse : Codable {
    let user : UserUpdate?
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
    }
}

struct UserUpdate : Codable {
    let id : String?
    let username : String?
    let name : String?
    let picture : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case username = "username"
        case name = "name"
        case picture = "picture"
    }
}
