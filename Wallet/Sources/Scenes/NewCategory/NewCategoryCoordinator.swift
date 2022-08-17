//
//  NewCategoryCoordinator.swift
//  Wallet

import UIKit

protocol NewCategoryCoordinatorDelegate: AnyObject {
    func newCategoryCoordinatorCategoryCreated(_ newCategory: CategoryModel)
}

final class NewCategoryCoordinator: Coordinator {
    init(navigationController: UINavigationController,
         dependencies: AppDependency) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    
    var delegate: NewCategoryCoordinatorDelegate?
    
    var newCategoryViewModel: NewCategoryViewModel?
    
    func start() {
        newCategoryViewModel = NewCategoryViewModel(model: CategoryModel.newCategory())
        newCategoryViewModel?.delegate = self
        if let newCategoryViewModel = newCategoryViewModel {
            let viewController = NewCategoryViewController(viewModel: newCategoryViewModel)
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}

extension NewCategoryCoordinator: NewCategoryViewModelDelegate {
    func newCategoryViewModelEnterName(_ currentValue: String?) {
        let viewModel = TextInputViewModel.makeCategoryName(isModal: true)
        viewModel.delegate = self
        viewModel.text = currentValue
        
        let controller = TextInputViewController(viewModel: viewModel)
        navigationController.present(controller, animated: true)
    }
    
    func newCategoryViewModelEnterType(_ currentValue: MoneyOperationType) {
        let viewModel = CategoryTypeViewModel(isModal: true)
        viewModel.delegate = self
        viewModel.chosenType = currentValue
        
        let controller = CategoryTypeViewController(viewModel: viewModel)
        navigationController.present(controller, animated: true)
    }
    
    func newCategoryViewModelEnterIcon() {
        let iconViewModel = IconPickerViewModel()
        iconViewModel.delegate = self
        if let viewModel = newCategoryViewModel {
            iconViewModel.setIcon(icon: viewModel.model.iconId ?? 0, color: viewModel.model.colorId ?? 0)
        }
        let viewController = IconPickerViewController(viewModel: iconViewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func newCategoryViewModelCreateCategory(_ newCategory: CategoryModel) {
        delegate?.newCategoryCoordinatorCategoryCreated(newCategory)
    }
}

extension NewCategoryCoordinator: TextInputViewModelDelegate {
    func textInputViewModelCloseButtonDidTap() {
        navigationController.dismiss(animated: true)
    }
    
    func textInputViewModelValueChanged(screen: TextInputScreenType, value: String?) {
        if screen == .categoryName {
            newCategoryViewModel?.changeName(value)
        }
        navigationController.dismiss(animated: true)
    }
}

extension NewCategoryCoordinator: CategoryTypeViewModelDelegate {
    func categoryTypeViewModelCloseButtonDidTap() {
        navigationController.dismiss(animated: true)
    }
    
    func categoryTypeViewModelValueChanged(_ value: MoneyOperationType?) {
        newCategoryViewModel?.changeType(value)
    }
}

extension NewCategoryCoordinator: IconPickerViewModelDelegate {
    func iconPickerViewModelChangeIcon(iconId: Int, colorId: Int) {
        newCategoryViewModel?.changeIcon(iconId: iconId, colorId: colorId)
        navigationController.popViewController(animated: true)
    }
}
