/// Notifying listeners when a tweet is posted.
protocol TweetNotifier {
    /// Notifies listeners that a tweet was posted.
    ///
    /// - Parameter tweet: The `Tweet` that was posted.
    func didPostTweet(_ tweet: Tweet)
}
