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
        window.backgroundColor = .systemBackground
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
    
    var errorPopupViewModel: ErrorPopupViewModel?
    
    func start() {
        showLaunchScreen()
        
        navigationController.navigationBar.tintColor = R.color.accentPurple()
        
        dependencies.signInService.checkSignInStatus { [weak self] isSignedIn in
            if isSignedIn {
                self?.startWallets()
            } else {
                self?.startOnboarding()
            }
        }
        
        if let window = window {
            errorPopupViewModel = ErrorPopupViewModel(parent: window)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.errorPopupViewModel?.showErrorPopup()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.errorPopupViewModel?.hideErrorPopup()
            }
        }
        
    }
    
    func createUser() {
//        dependencies.dataService.createUser(email: "test@example.com") {
//            self.dependencies.dataService.getCategories(for: .SPENDING) { values in
//                print("Categories")
//                values.forEach {
//                    print($0.name)
//                }
//            }
//        }
    }
    
    private func showLaunchScreen() {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchScreen = storyboard.instantiateViewController(withIdentifier: "LaunchScreen") as UIViewController
        navigationController.setViewControllers([launchScreen], animated: false)
    }
    
    private func startOnboarding() {
        let coordinator = OnboardingCoordinator(navigationController: navigationController,
                                                dependencies: dependencies)
        coordinator.delegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func startWallets() {
        let coordinator = WalletsCoordinator(navigationController: navigationController,
                                             dependencies: dependencies)
        coordinator.delegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingCoordinatorSuccessfulSignIn() {
        startWallets()
    }
}

extension AppCoordinator: WalletsCoordinatorDelegate {
    func walletsCoordinatorSignOut() {
        dependencies.signInService.signOut()
        childCoordinators = []
        startOnboarding()
    }
    
}
