//
//  Coordinator.swift
//  Wallet
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var dependencies: AppDependency { get set }
    init(navigationController: UINavigationController,
         dependencies: AppDependency)
    func start()
}
