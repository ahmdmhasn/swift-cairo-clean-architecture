import UIKit

protocol PostTweetCoordinator {
    /// Displays the view for creating a new tweet.
    func displayPostTweet()
}

/// The coordinator for the tweets feature, responsible for setting up and managing the view hierarchy.
final class TweetsCoordinator {
    private let tweetDataSource: TweetDataSource
    let navigationController: UINavigationController

    init(navigationController: UINavigationController,
         tweetDataSource: TweetDataSource) {
        self.navigationController = navigationController
        self.tweetDataSource = tweetDataSource
    }

    func start() {
        let useCase = DefaultTimelineUseCase(dataSource: tweetDataSource)
        let viewModel = TimelineViewModel(timelineUseCase: useCase, coordinator: self)
        let viewController = TimelineViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension TweetsCoordinator: PostTweetCoordinator {
    func displayPostTweet() {
        
    }
}
