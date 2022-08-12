//
//  TextInputCoordinator.swift
//  Wallet
//

import UIKit

final class TextInputCoordinator: Coordinator {
    init(navigationController: UINavigationController,
         dependencies: AppDependency = AppDependency()) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    
    func start() {
        let viewModel = TextInputViewModel.walletName()
        let controller = TextInputViewController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
}
