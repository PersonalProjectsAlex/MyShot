// Router for Travi
import Foundation

//let BASE_URL = "http://myshot.herokuapp.com/api"
let BASE_URL = "http://ec2-18-191-167-26.us-east-2.compute.amazonaws.com:5012/api"

struct Endpoints {
    
    // User
    static let LOGIN = "\(BASE_URL)/users/login"
    static let REGISTER = "\(BASE_URL)/users"
    static let CHECKNETWORK = "\(BASE_URL)/users/validate"
    static let UPDATEPROFILE = "\(BASE_URL)/users"
    
    // Offers
    static let GETOFFERSBAR = "\(BASE_URL)/offers"//TODO: Change API
    static let GETOFFERSBAR2 = "\(BASE_URL)/offers"//TODO: Change API
    static let GETALLOFFERS = "\(BASE_URL)/offers/list"
    
    //Comments
    static let GETCOMMENTS = "\(BASE_URL)/places"
    
    
}
