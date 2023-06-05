struct TweetData: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case text
        case user
        case createdAt = "created_at"
    }
    
    let id: String
    let text: String
    let user: UserData
    let createdAt: String    
}
