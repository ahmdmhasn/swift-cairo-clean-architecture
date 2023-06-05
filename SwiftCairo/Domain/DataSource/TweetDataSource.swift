/// A protocol that defines methods for fetching and posting tweets.
protocol TweetDataSource {
    /// Fetches the timeline of tweets for the current user.
    ///
    /// - Returns: An array of `Tweet` objects representing the timeline.
    ///
    /// - Throws: An error if there was an issue fetching the timeline.
    func fetchTimeline() async throws -> [Tweet]
    
    /// Posts a tweet to the datasource.
    ///
    /// - Parameter tweet: The `Tweet` object to post.
    ///
    /// - Returns: A boolean indicating whether the tweet was successfully posted.
    ///
    /// - Throws: An error if there was an issue posting the tweet.
    func postTweet(_ tweet: Tweet) async throws -> Bool
}
