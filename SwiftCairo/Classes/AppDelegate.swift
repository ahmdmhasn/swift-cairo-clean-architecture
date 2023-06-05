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
        // Override point for customization after application launch.
        let navigationController = UINavigationController()
        let tweetDataSource = TweetRepository(twitterAPI: ServiceLocator.twitterAPI,
                                              localDatabase: ServiceLocator.localDatabase)
        let coordinator = TweetsCoordinator(navigationController: navigationController,
                                            notificationCenter: .default,
                                            tweetDataSource: tweetDataSource)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        coordinator.start()
        
        return true
    }
}
