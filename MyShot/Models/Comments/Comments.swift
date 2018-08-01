

import Foundation
struct Comments : Codable {
	let id : String?
	let comment : String?
	let date : String?
	let user : UserComment?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case comment = "comment"
		case date = "date"
		case user = "user"
	}

	

}
