//
//  WalletsCoordinator.swift
//  Wallet
//

import UIKit

final class WalletsCoordinator: Coordinator {
    init(navigationController: UINavigationController,
         dependencies: AppDependency) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    
    func start() {
        let viewModel = WalletsViewModel()
        let viewController = WalletsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
