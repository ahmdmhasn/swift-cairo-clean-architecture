import UIKit

protocol PostTweetCoordinator {
    /// Displays the view for creating a new tweet.
    func displayPostTweet()
}

/// The coordinator for the tweets feature, responsible for setting up and managing the view hierarchy.
final class TweetsCoordinator {
    private let tweetRepository: TweetRepository
    private let notificationCenter: NotificationCenter
    let navigationController: UINavigationController

    init(navigationController: UINavigationController,
         notificationCenter: NotificationCenter,
         tweetRepository: TweetRepository) {
        self.navigationController = navigationController
        self.notificationCenter = notificationCenter
        self.tweetRepository = tweetRepository
    }

    func start() {
        let useCase = DefaultTimelineUseCase(repository: tweetRepository)
        let viewModel = TimelineViewModel(timelineUseCase: useCase, coordinator: self)
        let viewController = TimelineViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension TweetsCoordinator: PostTweetCoordinator {
    func displayPostTweet() {
        let tweetNotifier = DefaultTweetNotifier(notificationCenter: notificationCenter)
        let postTweetUseCase = DefaultPostTweetUseCase(sessionManager: ServiceLocator.sessionManager,
                                                       repository: tweetRepository,
                                                       notifier: tweetNotifier)
        let viewModel = PostTweetViewModel(postTweetUseCase: postTweetUseCase)
        let viewController = PostTweetHostingController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
