//
//  WalletDetailsCoordinator.swift
//  Wallet
//

import UIKit

final class WalletDetailsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    
    init(navigationController: UINavigationController, dependencies: AppDependency) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewModel = WalletDetailesViewModel(dependencies: dependencies)
        let viewController = WalletDetailesViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
