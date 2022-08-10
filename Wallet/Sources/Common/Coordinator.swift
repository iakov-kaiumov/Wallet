//
//  Coordinator.swift
//  Wallet
//

import UIKit

protocol Coordinator: AnyObject {
    init(navigationController: UINavigationController,
         dependencies: AppDependency)
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var dependencies: AppDependency { get set }
    func start()
}
