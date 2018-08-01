

import Foundation
struct Images : Codable {
	let url : String?

	enum CodingKeys: String, CodingKey {

		case url = "url"
	}

}
