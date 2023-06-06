import Foundation

extension TweetData {
    func toDomain() -> Tweet {
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: createdAt)!
        return Tweet(id: id, text: text, createdAt: date)
    }
}
