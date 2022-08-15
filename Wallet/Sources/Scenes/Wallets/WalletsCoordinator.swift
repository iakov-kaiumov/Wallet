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
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func goToWalletDetails(wallet: WalletModel) {
        let coordinator = WalletDetailsCoordinator(navigationController: navigationController,
                                                   dependencies: dependencies)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

// MARK: - WalletsViewModelDelegate
extension WalletsCoordinator: WalletsViewModelDelegate {
    func walletsViewModel(_ viewModel: WalletsViewModel, didSelectWallet wallet: WalletModel) {
        goToWalletDetails(wallet: wallet)
    }
    
}
