//
//  AppCoordinator.swift
//  Wallet
//

import UIKit

final class AppCoordinator: Coordinator {
    init(navigationController: UINavigationController,
         dependencies: AppDependency = AppDependency()) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    convenience init(scene: UIWindowScene) {
        let window = UIWindow(windowScene: scene)
        let rootViewController = UINavigationController()
        self.init(navigationController: rootViewController)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    var window: UIWindow?
    
    func start() {
        // TODO: - Check if user is logged in
        let walletDetailsCoordinator = WalletEditCoordinator(navigationController: navigationController,
                                                                dependencies: dependencies)
        childCoordinators.append(walletDetailsCoordinator)
        walletDetailsCoordinator.start()
    }
    
}
