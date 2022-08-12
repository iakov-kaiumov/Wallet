//
//  CurrenciesCoordinator.swift
//  Wallet
//

import UIKit

final class CurrenciesCoordinator: Coordinator {
    init(navigationController: UINavigationController,
         dependencies: AppDependency = AppDependency()) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    
    func start() {
        let viewModel = CurrenciesViewModel()
        let viewController = CurrenciesViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
