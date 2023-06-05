import Foundation

struct UserData: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageUrl = "profile_image_url"
    }
    
    let id: String
    let name: String
    let profileImageUrl: URL
}
