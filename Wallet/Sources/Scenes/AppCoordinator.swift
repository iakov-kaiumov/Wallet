//
//  AppCoordinator.swift
//  Wallet
//

import UIKit

final class AppCoordinator: Coordinator {
    // MARK: - Properties
    weak var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    var window: UIWindow?
    
    var errorPopupViewModel: ErrorPopupViewModel?
    
    private let internetChecker = try? Reachability()
    
    // MARK: - Init
    init(navigationController: UINavigationController,
         dependencies: AppDependency = AppDependency()) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        setupNavigationBar()
        internetChecker?.whenUnreachable = { _ in
            self.callBanner(type: .noInternet)
        }
        try? internetChecker?.startNotifier()
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
    
    // MARK: - Public Methods
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
        
    }
    
    func callBanner(type: ErrorPopupType) {
        errorPopupViewModel?.showErrorPopup(type: type)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.errorPopupViewModel?.hideErrorPopup()
        }
    }
    
    // MARK: - Private Methods
    private func showLaunchScreen() {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchScreen = storyboard.instantiateViewController(withIdentifier: "LaunchScreen") as UIViewController
        navigationController.setViewControllers([launchScreen], animated: false)
    }
    
    private func startOnboarding() {
        let coordinator = OnboardingCoordinator(navigationController: navigationController,
                                                dependencies: dependencies)
        coordinator.delegate = self
        coordinator.parent = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func startWallets() {
        let coordinator = WalletsCoordinator(navigationController: navigationController,
                                             dependencies: dependencies)
        coordinator.delegate = self
        coordinator.parent = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func setupNavigationBar() {
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithTransparentBackground()
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = R.color.background()
            
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = scrollAppearance
        } else {
            navigationController.navigationBar.standardAppearance = scrollAppearance
        }
        
    }
}

// MARK: - OnboardingCoordinatorDelegate
extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingCoordinatorSuccessfulSignIn() {
        startWallets()
    }
}

// MARK: - WalletsCoordinatorDelegate
extension AppCoordinator: WalletsCoordinatorDelegate {
    func walletsCoordinatorSignOut() {
        dependencies.signInService.signOut()
        childCoordinators = []
        startOnboarding()
    }
    
}
