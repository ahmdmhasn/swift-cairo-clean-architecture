/// An error that represents a failure to fetch the home timeline. This error can be caused by
/// empty results or an underlying error.
enum TimelineError: Error {
    case emptyResults
    case underlying(Error)
}

/// A protocol that defines methods for fetching the home timeline.
protocol TimelineUseCase {
    /// Fetches the home timeline asynchronously.
    ///
    /// - Returns: An array of `Tweet` objects representing the home timeline.
    ///
    /// - Throws: `TimelineError` if there was an issue fetching the timeline.
    func fetchHomeTimeline() async throws -> [Tweet]
}

/// A default implementation of the `TimelineUseCase` protocol that fetches the
/// home timeline from a `TweetRepository`.
final class DefaultTimelineUseCase: TimelineUseCase {
    private let repository: TweetRepository
    
    /// Creates a new `DefaultTimelineUseCase` instance.
    ///
    /// - Parameter repository: The `TweetDataSource` to use for fetching the home timeline.
    init(repository: TweetRepository) {
        self.repository = repository
    }
    
    func fetchHomeTimeline() async throws -> [Tweet] {
        do {
            let tweets = try await repository.fetchTimeline()
            if tweets.isEmpty {
                throw TimelineError.emptyResults
            }
            
            return tweets
        } catch {
            throw TimelineError.underlying(error)
        }
    }
}
