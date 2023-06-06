import Foundation

/// An error that represents a failure to post a tweet.
enum PostTweetError: Error {
    case invalidCurrentUser
    case underlying(Error)
}

/// Defines methods for posting a tweet.
protocol PostTweetUseCase {
    /// Executes the use case by posting a tweet with the given text.
    ///
    /// - Parameter tweetText: The text of the tweet to post.
    ///
    /// - Returns: A boolean indicating whether the tweet was successfully posted.
    ///
    /// - Throws: An error if the current user is invalid or if there was an underlying error while posting the tweet.
    func execute(tweetText: String) async throws -> Bool
}

/// A default implementation of the `PostTweetUseCase` protocol that posts a tweet and
/// notifies listeners using a `TweetNotifier`.
class DefaultPostTweetUseCase: PostTweetUseCase {
    private let sessionManager: SessionManager
    private let repository: TweetRepository
    private let notifier: TweetNotifier
    
    /// Creates a new `DefaultPostTweetUseCase` instance.
    ///
    /// - Parameter sessionManager: The `SessionManager` to use for retrieving the current user.
    /// - Parameter dataSource: The `TweetRepository` to use for posting the tweet.
    /// - Parameter notifier: The `TweetNotifier` to use for notifying listeners when a tweet is posted.
    init(sessionManager: SessionManager,
         repository: TweetRepository,
         notifier: TweetNotifier) {
        self.sessionManager = sessionManager
        self.repository = repository
        self.notifier = notifier
    }

    func execute(tweetText: String) async throws -> Bool {
        guard let currentUser = sessionManager.currentUser else {
            throw PostTweetError.invalidCurrentUser
        }
        
        let tweet = Tweet(id: UUID().uuidString,
                          text: tweetText,
                          user: currentUser,
                          createdAt: Date())
        
        do {
            let result = try await repository.postTweet(tweet)
            if result {
                notifier.didPostTweet(tweet)
            }
            
            return result
        } catch {
            throw PostTweetError.underlying(error)
        }
    }
}
