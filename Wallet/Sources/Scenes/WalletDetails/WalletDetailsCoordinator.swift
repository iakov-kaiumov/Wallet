//
//  WalletDetailsCoordinator.swift
//  Wallet
//

import UIKit

final class WalletDetailsCoordinator: Coordinator {
    weak var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    
    init(navigationController: UINavigationController, dependencies: AppDependency) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewModel = WalletDetailesViewModel(dependencies: dependencies)
        viewModel.delegate = self
        let viewController = WalletDetailesViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension WalletDetailsCoordinator: WalletDetailesViewModelDelegate {
    func walletDetailsViewModelAddOperation() {
        let coordinator = OperationEditCoordinator(navigationController: navigationController,
                                                   dependencies: dependencies)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func walletDetailsViewModelOpenSettings() {
        let coordinator = WalletEditCoordinator(navigationController: navigationController,
                                                dependencies: dependencies)
        childCoordinators.append(coordinator)
        coordinator.start(isCreatingMode: false)
    }
}
