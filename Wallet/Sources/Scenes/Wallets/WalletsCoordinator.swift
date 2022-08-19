//
//  WalletsCoordinator.swift
//  Wallet
//

import UIKit

protocol WalletsCoordinatorDelegate: AnyObject {
    func walletsCoordinatorSignOut()
}

final class WalletsCoordinator: Coordinator {
    weak var parent: Coordinator?
    
    init(navigationController: UINavigationController,
         dependencies: AppDependency) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    weak var delegate: WalletsCoordinatorDelegate?
    
    // MARK: - Public Methods
    func start() {
        let viewModel = WalletsViewModel(dependencies: dependencies)
        viewModel.delegate = self
        let viewController = WalletsViewController(viewModel: viewModel)
        DispatchQueue.main.async {
            self.navigationController.setViewControllers([viewController], animated: true)
        }
        
    }
    
    // MARK: - Private Methods
    private func goToWalletDetails(wallet: WalletModel) {
        let coordinator = WalletDetailsCoordinator(navigationController: navigationController,
                                                   dependencies: dependencies)
        childCoordinators.append(coordinator)
        coordinator.parent = self
        coordinator.start(wallet: wallet)
    }
}

// MARK: - WalletsViewModelDelegate
extension WalletsCoordinator: WalletsViewModelDelegate {
    func walletsViewModel(_ viewModel: WalletsViewModel, didReceiveError error: Error) {
        callBanner(type: .unknownError)
    }
    
    func walletsViewModel(_ viewModel: WalletsViewModel, didSelectWallet wallet: WalletModel) {
        goToWalletDetails(wallet: wallet)
    }
    
    func walletsViewModelDidAskToCreateWallet() {
        let coordinator = WalletEditCoordinator(navigationController: navigationController, dependencies: dependencies)
        childCoordinators.append(coordinator)
        coordinator.parent = self
        coordinator.start(isCreatingMode: true)
    }
    
    func walletsViewModelSignOut() {
        delegate?.walletsCoordinatorSignOut()
    }
    
    func walletsViewModelEditWallet(wallet: WalletModel) {
        let coordinator = WalletEditCoordinator(navigationController: navigationController, dependencies: dependencies)
        childCoordinators.append(coordinator)
        coordinator.start(isCreatingMode: false, wallet: wallet)
    }
}
