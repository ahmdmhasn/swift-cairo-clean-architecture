protocol TwitterAPI {
    func fetchHomeTimeline() async throws -> [TweetData]
    func postTweet(_ tweet: Tweet) async throws
}
