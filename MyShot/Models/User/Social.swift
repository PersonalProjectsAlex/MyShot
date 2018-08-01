//
//  Social.swift
//  MyShot
//
//  Created by Mac on 2/6/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import Foundation
struct Social: Codable {
    let user : User?
    let newUser: Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case user
        case newUser = "newUser"
        
    }
    
    
}
