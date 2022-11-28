//
//  AppDelegate.swift
//  MARVEL
//
//  Created by Владимир  Лукоянов on 28.11.2022.
//

import UIKit
@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: MarvelViewController())
        return true
    }
}
