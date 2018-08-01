//
//  Login.swift
//  MyShot
//
//  Created by Administrador on 31/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import Foundation
struct Login : Codable {
    let user : User?
    let status : Int?
    let msg: String?
    enum CodingKeys: String, CodingKey {
        
        case user = "user"
        case status = "status"
        case msg = "msg"
    }
}
