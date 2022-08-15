//
//  AppCoordinator.swift
//  Wallet
//

import UIKit
import GoogleSignIn

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
        navigationController.navigationBar.tintColor = R.color.accentPurple()
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            guard let self = self else {
                return
            }
            
            if error != nil || user == nil {
                let coordinator = OnboardingCoordinator(navigationController: self.navigationController, dependencies: self.dependencies)
                self.childCoordinators.append(coordinator)
                coordinator.start()
            } else {
                let coordinator = WalletsCoordinator(navigationController: self.navigationController, dependencies: self.dependencies)
                coordinator.delegate = self
                self.childCoordinators.append(coordinator)
                coordinator.start()
            }
        }
    }
}

extension AppCoordinator: WalletsCoordinatorDelegate {
    func walletsCoordinatorSignOut() {
        GIDSignIn.sharedInstance.signOut()
        
        childCoordinators = []
        
        let coordinator = OnboardingCoordinator(navigationController: navigationController, dependencies: dependencies)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
