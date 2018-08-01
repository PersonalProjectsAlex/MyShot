import Foundation
struct Offers : Codable {
	let title : String?
	let code : String?
    let overdue: String?
    let image: String?

	enum CodingKeys: String, CodingKey {

		case title = "title"
		case code = "code"
        case overdue = "overdue"
        case image = "image"
	}

	

}


