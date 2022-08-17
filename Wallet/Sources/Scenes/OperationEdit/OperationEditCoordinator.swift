//
//  OperationEditCoordinator.swift
//  Wallet
//

import UIKit

final class OperationEditCoordinator: Coordinator {
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
        let model = OperationModel.makeTestModel()
        operationViewModel = OperationViewModel(model: model)
        operationViewModel?.delegate = self
        guard let operationViewModel = operationViewModel else {
            return
        }
        let controller = OperationViewController(viewModel: operationViewModel)
        navigationController.pushViewController(controller, animated: true)
    }
}

extension OperationEditCoordinator: OperationViewModelDelegate {
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
    
    func operationViewModelEnterCategory(_ currentValue: CategoryModel?) {
        let viewModel = CategoryViewModel()
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
                operationViewModel?.changeAmount(Decimal(Double(value) ?? 0))
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
    func categoryViewModelCloseButtonDidTap() {
        navigationController.dismiss(animated: true)
    }
    
    func categoryViewModelValueChanged(_ value: CategoryModel?) {
        operationViewModel?.changeCategory(value)
    }
    
    func categoryViewModelCreateCategory() {
        let coordinator = NewCategoryCoordinator(navigationController: navigationController,
                                                 dependencies: dependencies)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension OperationEditCoordinator: NewCategoryCoordinatorDelegate {
    func newCategoryCoordinatorCategoryCreated(_ newCategory: CategoryModel) {
        navigationController.popViewController(animated: true)
        navigationController.popViewController(animated: true)
        operationViewModel?.changeCategory(newCategory)
    }
}
