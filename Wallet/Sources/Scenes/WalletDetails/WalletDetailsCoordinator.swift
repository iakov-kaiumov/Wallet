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
        
    }
    
    func start(wallet: WalletModel) {
        let viewModel = WalletDetailesViewModel(dependencies: dependencies, wallet: wallet)
        viewModel.delegate = self
        let viewController = WalletDetailesViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension WalletDetailsCoordinator: WalletDetailesViewModelDelegate {
    func walletDetailsViewModel(_ viewModel: WalletDetailesViewModel, didReceiveError error: Error) {
        callBanner(type: .unknownError)
    }
    
    func walletDetailsViewModelAddOperation(wallet: WalletModel) {
        let coordinator = OperationEditCoordinator(navigationController: navigationController,
                                                   dependencies: dependencies)
        childCoordinators.append(coordinator)
        coordinator.parent = self
        coordinator.start(walletID: wallet.id, currency: wallet.currency)
    }
    
    func walletDetailsViewModelOpenSettings(wallet: WalletModel) {
        let coordinator = WalletEditCoordinator(navigationController: navigationController,
                                                dependencies: dependencies)
        childCoordinators.append(coordinator)
        coordinator.parent = self
        coordinator.start(isCreatingMode: false, wallet: wallet)
    }
}
