//
//  IconPickerCoordinator.swift
//  Wallet

import UIKit

final class IconPickerCoordinator: Coordinator {
    init(navigationController: UINavigationController,
         dependencies: AppDependency) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    
    func start() {
        let viewModel = IconPickerViewModel()
        let viewController = IconPickerViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
