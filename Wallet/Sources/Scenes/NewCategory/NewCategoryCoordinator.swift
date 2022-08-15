//
//  NewCategoryCoordinator.swift
//  Wallet

import UIKit

final class NewCategoryCoordinator: Coordinator {
    init(navigationController: UINavigationController,
         dependencies: AppDependency) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    
    func start() {
        let viewModel = NewCategoryViewModel()
        let viewController = NewCategoryViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
