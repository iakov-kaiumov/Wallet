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
    
    func start() {
        let viewModel = OnboardingViewModel()
        viewModel.delegate = self
        let viewController = OnboardingViewController(viewModel: viewModel)
        
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension OnboardingCoordinator: OnboardingViewModelDelegate {
    func onboardingViewModelSuccessfulSignIn() {
        let coordinator = WalletsCoordinator(navigationController: navigationController, dependencies: dependencies)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
