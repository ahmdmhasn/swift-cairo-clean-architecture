import CoreData

extension TweetEntity {
    /// Updates the TweetEntity with the a Tweet.
    public func update(with tweet: Tweet) {
        self.id = tweet.id
        self.text = tweet.text
        self.createdAt = tweet.createdAt
    }
    
    /// Returns a Tweet version of the receiver.
    public func toDomain() -> Tweet {
        return Tweet(id: id,
                     text: text,
                     user: user.toDomain(),
                     createdAt: createdAt)
    }
}
