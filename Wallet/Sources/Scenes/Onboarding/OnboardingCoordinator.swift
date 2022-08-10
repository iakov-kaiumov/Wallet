//
//  MainCoordinator.swift
//  Wallet
//

import UIKit

final class OnboardingCoordinator: Coordinator {
    init(navigationController: UINavigationController,
         dependencies: AppDependency = AppDependency()) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    var window: UIWindow?
    
    func start() {
        let viewModel = OnboardingViewModel()
        let viewController = OnboardingViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
