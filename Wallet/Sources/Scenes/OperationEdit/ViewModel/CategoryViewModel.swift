//
//  CategoryViewModel.swift
//  Wallet
//

import Foundation

protocol CategoryViewModelDelegate: AnyObject {
    func categoryViewModelCloseButtonDidTap()
    
    func categoryViewModelValueChanged(_ value: CategoryModel?)
    
    func categoryViewModelCreateCategory(type: MoneyOperationType)
    
    func categoryViewModel(_ viewModel: CategoryViewModel, didReceiveError error: Error)
}

final class CategoryViewModel {
    typealias Dependencies = HasCategoryService
    weak var delegate: CategoryViewModelDelegate?
    
    var categories: [CategoryModel] = []
    
    var chosenCategory: CategoryModel?
    var operationType: MoneyOperationType
    
    var reloadData: (() -> Void)?
    var showProgressView: ((_ isOn: Bool) -> Void)?
    
    lazy var iconBuilder = IconViewModelBuilder()
    lazy var categoryModelBuilder = CategoryModelBuilder()
    private var dependencies: Dependencies
    
    init(dependencies: Dependencies, type: MoneyOperationType) {
        operationType = type
        self.dependencies = dependencies
        loadData()
    }
    
    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showProgressView?(true)
        }
        dependencies.categoryService.categoryNetworkServiceGetAll(type: operationType.convertToCategoryType()) { [weak self] result in
            switch result {
            case .success(let models):
                self?.categories = self?.categoryModelBuilder.build(models) ?? []
                DispatchQueue.main.async {
                    self?.reloadData?()
                    self?.showProgressView?(false)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showError(error: error)
                }
            }
        }
    }
    
    func cellDidTap(at indexPath: IndexPath) {
        if indexPath.section == 1 {
            delegate?.categoryViewModelCreateCategory(type: operationType)
        } else {
            chosenCategory = categories[indexPath.row]
            delegate?.categoryViewModelValueChanged(chosenCategory)
        }
    }
    
    func closeButtonDidTap() {
        delegate?.categoryViewModelCloseButtonDidTap()
    }
    
    // MARK: - Private
    
    private func showError(error: NetworkError) {
        self.delegate?.categoryViewModel(self, didReceiveError: error)
    }
}
