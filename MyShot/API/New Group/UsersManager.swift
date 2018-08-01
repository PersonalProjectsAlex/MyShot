
import Foundation
import Alamofire

class UsersManager: APIManager {
    
    
    /// Home detail.
    ///
    ///
    ///     - completionHandler: Callback with Event value
    
    func Login(params: Params,completionHandler handler: @escaping (Login?) -> Void) {
        
        let eventEndpoint = "\(Endpoints.LOGIN)"
        
        request(endpoint: eventEndpoint,  completionHandler: handler, method: .post, params: params, encoding: JSONEncoding.default)
    }
    
    func RegisterFacebook(params: Params,completionHandler handler: @escaping (RegisterResponse?) -> Void) {
        
        let eventEndpoint = "\(Endpoints.REGISTER)"
        
        request(endpoint: eventEndpoint,  completionHandler: handler, method: .post, params: params, encoding: JSONEncoding.default)
    }
    
    func CheckSocial(params: Params,completionHandler handler: @escaping (Social?) -> Void) {
        
        let eventEndpoint = "\(Endpoints.CHECKNETWORK)"
        
        request(endpoint: eventEndpoint,  completionHandler: handler, method: .post, params: params, encoding: JSONEncoding.default)
    }
    
    func updateProfile(params: Params,completionHandler handler: @escaping (UpdateProfileResponse?) -> Void) {
        
        let eventEndpoint = "\(Endpoints.REGISTER)"
        
        request(endpoint: eventEndpoint,  completionHandler: handler, method: .put, params: params)
    }
    
}
