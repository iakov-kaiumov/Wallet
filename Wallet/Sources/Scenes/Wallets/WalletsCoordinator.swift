//
//  WalletsCoordinator.swift
//  Wallet
//

import UIKit

protocol WalletsCoordinatorDelegate: AnyObject {
    func walletsCoordinatorSignOut()
}

final class WalletsCoordinator: Coordinator {
    init(navigationController: UINavigationController,
         dependencies: AppDependency) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    var delegate: WalletsCoordinatorDelegate?
    
    func start() {
        let viewModel = WalletsViewModel()
        viewModel.delegate = self
        let viewController = WalletsViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
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
    
    func walletsViewModelDidAskToCreateWallet() {
        let coordinator = WalletEditCoordinator(navigationController: navigationController, dependencies: dependencies)
        childCoordinators.append(coordinator)
        coordinator.start(isCreatingMode: true)
    }
    
    func walletsViewModelSignOut() {
        delegate?.walletsCoordinatorSignOut()
    }
}
