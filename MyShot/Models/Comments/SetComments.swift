//
//  SetComments.swift
//  MyShot
//
//  Created by Administrador on 16/06/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import Foundation
struct SetCommentsMessage: Codable {
    let msg : String?
    let comment : Comment?
    
    enum CodingKeys: String, CodingKey {
        
        case msg = "msg"
        case comment
    }
    
    
}
