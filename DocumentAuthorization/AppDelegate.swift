//
//  AppDelegate.swift
//  DocumentAuthorization
//
//  Created by Dzhami on 02.11.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = AppCoordinator(window: window!)
        coordinator?.start()
        window?.makeKeyAndVisible()
        return true
    }
}


