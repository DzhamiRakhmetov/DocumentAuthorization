//
//  AppCoordinator.swift
//  DocumentAuthorization
//
//  Created by Dzhami on 08.11.2023.
//

import UIKit

class AppCoordinator {
    let window: UIWindow
    let navigationController: UINavigationController
    let loginByDocumentViewModel = LoginByDocumentViewModel()
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        window.rootViewController = navigationController
    }
    
    func start() {
        let loginByDocumentVC = LoginByDocumentViewController(viewModel: loginByDocumentViewModel)
        loginByDocumentVC.coordinator = self
        navigationController.pushViewController(loginByDocumentVC, animated: false)
    }
}
