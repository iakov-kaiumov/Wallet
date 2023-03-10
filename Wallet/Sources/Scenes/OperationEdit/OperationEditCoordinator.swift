//
//  OperationEditCoordinator.swift
//  Wallet
//

import UIKit

final class OperationEditCoordinator: Coordinator {
    weak var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    
    var operationViewModel: OperationViewModel?
    
    init(navigationController: UINavigationController,
         dependencies: AppDependency = AppDependency()) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let model = OperationModel.makeEmptyModel()
        operationViewModel = OperationViewModel(dependencies: dependencies, model: model)
        operationViewModel?.delegate = self
        guard let operationViewModel = operationViewModel else {
            return
        }
        let controller = OperationViewController(viewModel: operationViewModel)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func start(walletID: Int, currency: CurrencyModel) {
        var model = OperationModel.makeEmptyModel()
        model.walletId = walletID
        model.currency = currency
        operationViewModel = OperationViewModel(dependencies: dependencies, model: model)
        operationViewModel?.delegate = self
        guard let operationViewModel = operationViewModel else {
            return
        }
        let controller = OperationViewController(viewModel: operationViewModel)
        navigationController.pushViewController(controller, animated: true)
    }
}

extension OperationEditCoordinator: OperationViewModelDelegate {
    func operationViewModel(_ viewModel: OperationViewModel, didReceiveError error: Error) {
        callBanner(type: .unknownError)
    }
    
    func operationViewModelEnterAmount(_ currentValue: Decimal?) {
        let viewModel = TextInputViewModel.makeOperationAmount(isModal: true)
        viewModel.delegate = self
        viewModel.text = ""
        if let currentValue = currentValue {
            viewModel.text = currentValue.displayString()
        }
        
        let controller = TextInputViewController(viewModel: viewModel)
        navigationController.present(controller, animated: true)
    }
    
    func operationViewModelEnterType(_ currentValue: MoneyOperationType) {
        let viewModel = OperationTypeViewModel(isModal: true)
        viewModel.delegate = self
        viewModel.chosenType = currentValue
        
        let controller = OperationTypeViewController(viewModel: viewModel)
        navigationController.present(controller, animated: true)
    }
    
    func operationViewModelEnterCategory(_ currentValue: CategoryModel?, _ currentType: MoneyOperationType) {
        let viewModel = CategoryViewModel(dependencies: dependencies, type: currentType)
        viewModel.delegate = self
        viewModel.chosenCategory = currentValue
        
        let controller = CategoryListViewController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func operationViewModelDidFinish() {
        navigationController.popViewController(animated: true)
    }
    
}

extension OperationEditCoordinator: TextInputViewModelDelegate {
    func textInputViewModelCloseButtonDidTap() {
        navigationController.dismiss(animated: true)
    }
    
    func textInputViewModelValueChanged(screen: TextInputScreenType, value: String?) {
        switch screen {
        case .operationAmount:
            if let value = value {
                operationViewModel?.changeAmount(value.toDecimal)
            } else {
                operationViewModel?.changeAmount(0.0)
            }
        default:
            break
        }
        navigationController.dismiss(animated: true)
    }
}

extension OperationEditCoordinator: OperationTypeViewModelDelegate {
    func operationTypeViewModelCloseButtonDidTap() {
        navigationController.dismiss(animated: true)
    }
    
    func operationTypeViewModelValueChanged(_ value: MoneyOperationType?) {
        operationViewModel?.changeType(value)
    }
}

extension OperationEditCoordinator: CategoryViewModelDelegate {
    func categoryViewModel(_ viewModel: CategoryViewModel, didReceiveError error: Error) {
        callBanner(type: .unknownError)
    }
    
    func categoryViewModelCloseButtonDidTap() {
        navigationController.popViewController(animated: true)
    }
    
    func categoryViewModelValueChanged(_ value: CategoryModel?) {
        operationViewModel?.changeCategory(value)
    }
    
    func categoryViewModelCreateCategory(type: MoneyOperationType) {
        let coordinator = NewCategoryCoordinator(navigationController: navigationController, dependencies: dependencies)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start(type: type)
    }
}

extension OperationEditCoordinator: NewCategoryCoordinatorDelegate {
    func newCategoryCoordinatorCategoryCreated(_ newCategory: CategoryModel) {
        navigationController.popViewController(animated: true)
        navigationController.popViewController(animated: true)
        operationViewModel?.changeCategory(newCategory)
    }
}
