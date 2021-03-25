//
//  AppDelegate.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 19.03.2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: Coordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        if #available(iOS 13, *) {
            // Do nothing, setup is in SceneDelegate
        } else {
            let window = UIWindow()

            let navController = UINavigationController()

            self.window = window
            self.window?.makeKeyAndVisible()

            window.rootViewController = navController
            let rootController = window.rootViewController

            if let root = rootController as? UINavigationController {
                let router = Router(rootController: root)
                appCoordinator = ApplicationCoordinator(router: router,
                                                        coordinatorFactory: CoordinatorFactory())
            }

            appCoordinator?.start()
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly
        //  after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
