//
//  CommentsManager.swift
//  MyShot
//
//  Created by Administrador on 15/06/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import Foundation
class CommentsManager: APIManager {
    
    
    /// Home detail.
    ///
    ///
    ///     - completionHandler: Callback with Event value
    
    func getCommments(idcommerce: String,completionHandler handler: @escaping (CommentsArray?) -> Void) {
        
        let eventEndpoint = "\(Endpoints.GETCOMMENTS)/\(idcommerce)/comments"
        
        request(endpoint: eventEndpoint, completionHandler: handler, method: .get)
    }
    
    func setCommments(idcommerce: String,params: Params,completionHandler handler: @escaping (SetCommentsMessage?) -> Void) {
        
        let eventEndpoint = "\(Endpoints.GETCOMMENTS)/\(idcommerce)/comments"
        
        request(endpoint: eventEndpoint, completionHandler: handler, method: .post, params: params)
    }
    
}
