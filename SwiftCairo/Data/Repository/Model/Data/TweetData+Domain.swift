extension TweetData {
    func toDomain() -> Tweet {
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: createdAt)!
        return Tweet(id: id, text: text, user: user.toDomain(), createdAt: date)
    }
}
