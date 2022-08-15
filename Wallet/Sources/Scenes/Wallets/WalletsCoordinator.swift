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
        viewModel.delegate = self
        let viewController = WalletsViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension WalletsCoordinator: WalletsViewModelDelegate {
    func walletsViewModelCreateWallet() {
        let coordinator = WalletEditCoordinator(navigationController: navigationController, dependencies: dependencies)
        childCoordinators.append(coordinator)
        coordinator.start(isCreatingMode: true)
    }
}
