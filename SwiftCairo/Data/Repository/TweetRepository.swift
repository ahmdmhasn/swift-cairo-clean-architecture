import Foundation

final class TweetRepository: TweetDataSource {
    private let twitterAPI: TwitterAPI
    private let localDatabase: LocalDatabase
    
    init(twitterAPI: TwitterAPI, localDatabase: LocalDatabase) {
        self.twitterAPI = twitterAPI
        self.localDatabase = localDatabase
    }
    
    func fetchTimeline() async throws -> [Tweet] {
        do {
            let newTweets = try await twitterAPI.fetchHomeTimeline()
            guard !newTweets.isEmpty else {
                throw NSError(domain: "Empty tweets!", code: -1)
            }
            
            let tweets = newTweets.map { $0.toDomain() }
            try await localDatabase.save(tweets: tweets)
            return tweets
        } catch {
            return try await localDatabase.fetchHomeTimeline()
        }
    }
    
    func postTweet(_ tweet: Tweet) async throws -> Bool {
        let result = try await twitterAPI.postTweet(tweet) as Any?
        let tweetPosted = result != nil
        if tweetPosted {
            try await localDatabase.save(tweets: [tweet])
        }
        
        return tweetPosted
    }
}
