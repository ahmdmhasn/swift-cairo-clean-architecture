//
//  AppDelegate.swift
//  SwiftCairo
//
//  Created by Ahmed M. Hassan on 05/06/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// Provide access to default `LocalDatabase`
        let localDatabase: LocalDatabase = CoreDataDatabase()
        
        /// Provide access to default `TwitterAPI`
        let twitterAPI: TwitterAPI = URLSessionTwitterAPI(session: .shared)

        /// Default `TweetRepository`
        let tweetRepository = DefaultTweetRepository(twitterAPI: twitterAPI,
                                                     localDatabase: localDatabase)

        let useCase = DefaultTimelineUseCase(repository: tweetRepository)
        let viewModel = TimelineViewModel(timelineUseCase: useCase)
        let viewController = TimelineViewController(viewModel: viewModel)

        let navigationController = UINavigationController()
        navigationController.pushViewController(viewController, animated: true)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
