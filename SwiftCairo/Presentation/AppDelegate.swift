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
        // Provide access to default `LocalDatabase`
        let localDatabase: LocalDatabase = CoreDataDatabase()

        // Provide access to default `TwitterAPI`
        let twitterAPI: TwitterAPI = URLSessionTwitterAPI(session: .shared)

        // Default `TweetRepository` that utilizes the `TwitterAPI` and `LocalDatabase`
        let tweetRepository = DefaultTweetRepository(twitterAPI: twitterAPI,
                                                     localDatabase: localDatabase)

        // Create a `DefaultTimelineUseCase` using the `TweetRepository`
        let useCase = DefaultTimelineUseCase(repository: tweetRepository)

        // Create a ViewModel & ViewController
        let viewModel = TimelineViewModel(timelineUseCase: useCase)
        let viewController = TimelineViewController(viewModel: viewModel)

        // Create a `UINavigationController` and push the `TimelineViewController` on top of it
        let navigationController = UINavigationController()
        navigationController.pushViewController(viewController, animated: true)

        // Create a `UIWindow` and set the `navigationController` as its root view controller
        // Make the `UIWindow` visible
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
