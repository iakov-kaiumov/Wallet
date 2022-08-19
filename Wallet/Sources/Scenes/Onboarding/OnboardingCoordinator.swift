//
//  MainCoordinator.swift
//  Wallet
//

import UIKit

protocol OnboardingCoordinatorDelegate: AnyObject {
    func onboardingCoordinatorSuccessfulSignIn()
}

final class OnboardingCoordinator: Coordinator {
    weak var parent: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    
    weak var delegate: OnboardingCoordinatorDelegate?
    
    init(navigationController: UINavigationController,
         dependencies: AppDependency = AppDependency()) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
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
    
    func onboardingViewModel(_ viewModel: OnboardingViewModel, didReceiveError error: Error) {
        callBanner(type: .unknownError)
    }
}
