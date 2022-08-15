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
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            guard let self = self else {
                return
            }
            
            if error != nil || user == nil {
                let onboardingCoordinator = OnboardingCoordinator(navigationController: self.navigationController, dependencies: self.dependencies)
                self.childCoordinators.append(onboardingCoordinator)
                onboardingCoordinator.start()
            } else {
                let onboardingCoordinator = WalletsCoordinator(navigationController: self.navigationController, dependencies: self.dependencies)
                self.childCoordinators.append(onboardingCoordinator)
                onboardingCoordinator.start()
            }
        }
    }
    
}
