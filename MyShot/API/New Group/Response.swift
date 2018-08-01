//
//  Response.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/20/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

/// Response
struct Response<T: Codable>: Codable {
    let result: T?
    
}

struct Empty: Codable {}

