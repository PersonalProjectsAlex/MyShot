import Foundation

struct UserComment : Codable {
	let id : String?
	let name : String?
	let picture : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case picture = "picture"
	}

	

}
