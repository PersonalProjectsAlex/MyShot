//
//  UserSIngleton.swift
//  MyShot
//
//  Created by Administrador on 8/06/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin

struct GlobalSettings{
    let defaults = UserDefaults.standard
    let loginManager = LoginManager()
}

class UserSingleton {
    static let shared = UserSingleton()
    private init() {}
    // MARK: - Let-Var
    
    // MARK: - SetUps / Funcs
    //Setting a way to keep the user logged
    func keepLogged(_ logged: String) {
        GlobalSettings().defaults.set(logged, forKey:DefaultKeys.logged)
    }
    
    //Setting info user keys
    func setCurrentLoginID(_ struserid: String) {
        GlobalSettings().defaults.set(struserid, forKey:DefaultKeys.userID)
    }
    
    //Setting username from update profile
    func setNewPhoto(_ strphotourl: String) {
        GlobalSettings().defaults.set(strphotourl, forKey:DefaultKeys.userPhoto)
    }
    
    
    
    //Setting photo from update profile
    func setUsername(_ strusername: String) {
        GlobalSettings().defaults.set(strusername, forKey:DefaultKeys.userPhoto)
    }
    
    //Setting info user keys
    func setCurrentUser(_ userName: String?, _ userPhoto: String?, _ userID: String?) {
        GlobalSettings().defaults.set(userName, forKey:DefaultKeys.userName)
        GlobalSettings().defaults.set(userPhoto, forKey:DefaultKeys.userPhoto)
          GlobalSettings().defaults.set(userID, forKey:DefaultKeys.userID)
    }
    
    //Calling a key for a user
    func loggedUser(key: String) -> String {
        let str = GlobalSettings().defaults.object(forKey: key) as? String
        return str == nil ? "" : str!
    }
    
    //Deleting user settings
    func resetUser(){
        GlobalSettings().defaults.removeObject(forKey: DefaultKeys.logged)
        GlobalSettings().defaults.removeObject(forKey: DefaultKeys.userPhoto)
        GlobalSettings().defaults.removeObject(forKey: DefaultKeys.userName)
        GlobalSettings().defaults.removeObject(forKey: DefaultKeys.userID)
        
    }
    
    
    func facebookSignOut(){
        GlobalSettings().loginManager.logOut()
    }
    
}

