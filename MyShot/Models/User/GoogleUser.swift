//
//  GoogleUser.swift
//  MyShot
//
//  Created by Mac on 12/6/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import Foundation

struct GoogleUser {
    var userName = String()
    var email = String()
    var googletoken = String()
    var photo = String()
    
    

    
    init ( userName: String,email: String, googletoken: String, photo:String) {
        
        self.userName = userName
        self.email = email
        self.googletoken = googletoken
        self.photo = photo
    }
    
}
