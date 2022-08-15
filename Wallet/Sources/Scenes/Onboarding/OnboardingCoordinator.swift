//
//  MainCoordinator.swift
//  Wallet
//

import UIKit

protocol OnboardingCoordinatorDelegate: AnyObject {
    func onboardingCoordinatorSuccessfulSignIn()
}

final class OnboardingCoordinator: Coordinator {
    init(navigationController: UINavigationController,
         dependencies: AppDependency = AppDependency()) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    
    var delegate: OnboardingCoordinatorDelegate?
    
    func start() {
        let viewModel = OnboardingViewModel(dependencies: dependencies)
        viewModel.delegate = self
        let viewController = OnboardingViewController(viewModel: viewModel)
        
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension OnboardingCoordinator: OnboardingViewModelDelegate {
    func onboardingViewModelSuccessfulSignIn() {
        delegate?.onboardingCoordinatorSuccessfulSignIn()
    }
}
