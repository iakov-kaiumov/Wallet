//
//  Coordinator.swift
//  Wallet
//

import UIKit

protocol Coordinator: AnyObject {
    var parent: Coordinator? { get }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var dependencies: AppDependency { get set }
    init(navigationController: UINavigationController,
         dependencies: AppDependency)
    func start()
    func callBanner(type: ErrorPopupType)
}

extension Coordinator {
    func callBanner(type: ErrorPopupType) {
        parent?.callBanner(type: type)
    }
}
