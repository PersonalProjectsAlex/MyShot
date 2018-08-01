

//
//  GeneralOffers.swift
//  MyShot
//
//  Created by Mac on 18/6/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import Foundation
struct GeneralOffers : Codable {
    let _id : String?
    let place_id : String?
    let title : String?
    let code : String?
    let overdue : String?
    let image : String?
    let place : Commerces?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case place_id = "place_id"
        case title = "title"
        case code = "code"
        case overdue = "overdue"
        case image = "image"
        case place = "place"
    }
}
