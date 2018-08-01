
import Foundation

class CommercesManager: APIManager {
    

    /// Home detail.
    ///
    ///
    ///     - completionHandler: Callback with Event value
 
    func LoadBars(completionHandler handler: @escaping ([Commerces]?) -> Void) {
        
        let eventEndpoint = "\(Endpoints.GETOFFERSBAR)"
        
        request(endpoint: eventEndpoint, completionHandler: handler, method: .get)
    }
    
    func LoadBarsRegion(lat:Double, lon: Double,completionHandler handler: @escaping ([Commerces]?) -> Void) {
        
        let eventEndpoint = "\(Endpoints.GETOFFERSBAR)?lat=\(lat)&lon=\(lon)"
        
        request(endpoint: eventEndpoint, completionHandler: handler, method: .get)
    }
    
    func LoadBarsRestaurant(completionHandler handler: @escaping ([Commerces]?) -> Void) {
        
        let eventEndpoint = "\(Endpoints.GETOFFERSBAR2)"
        
        request(endpoint: eventEndpoint, completionHandler: handler, method: .get)
    }

    func LoadGeneralOffers(completionHandler handler: @escaping ([GeneralOffers]?) -> Void) {
        
        let eventEndpoint = "\(Endpoints.GETALLOFFERS)"
        
        request(endpoint: eventEndpoint, completionHandler: handler, method: .get)
    }
    
}

