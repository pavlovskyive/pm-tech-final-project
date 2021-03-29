//
//  AppDelegate.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 19.03.2021.
//

import UIKit
import Firebase
import SwiftyBeaver

let log = SwiftyBeaver.self

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: Coordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let platform = SBPlatformDestination(appID: "Gw3AJo",
                                             appSecret: "afxsclzQ9qhnltomqgiu2vxlgc0rqwoc",
                                             encryptionKey: "cWtgjh7gtqdkhplpwlKvrigmTDwraUof")

        log.addDestination(platform)
        FirebaseApp.configure()
        NetworkMonitor.shared.startMonitoring()

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

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly
        //  after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
