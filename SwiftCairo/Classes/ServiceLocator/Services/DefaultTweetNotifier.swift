import Foundation

final class DefaultTweetNotifier: TweetNotifier {
    let notificationCenter: NotificationCenter
    
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }
    
    func didPostTweet(_ tweet: Tweet) {
        notificationCenter.post(name: Notification.Name("Did Post Tweet"), object: tweet)
    }
}
