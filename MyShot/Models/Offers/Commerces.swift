
import Foundation
struct Commerces: Codable {
    let id: String?
    let name : String?
    let lat : Double?
    let lon : Double?
    let distance : Double?
    let image : String?
    let phone : Int?
    let types : [String]?
    let gallery : [String]?
    let offers : [Offers]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case lat = "lat"
        case lon = "lon"
        case distance = "distance"
        case image = "image"
        case phone = "phone"
        case types = "types"
        case gallery = "gallery"
        case offers = "offers"
    }
}
