//
//  CategoryViewModel.swift
//  Wallet
//

import Foundation

protocol CategoryViewModelDelegate: AnyObject {
    func categoryViewModelCloseButtonDidTap()
    
    func categoryViewModelValueChanged(_ value: CategoryModel?)
    
    func categoryViewModelCreateCategory()
}

final class CategoryViewModel {
    weak var delegate: CategoryViewModelDelegate?
    
    var categories: [CategoryModel] = []
    
    var chosenCategory: CategoryModel?
    
    var reloadData: (() -> Void)?
    
    init() {
        loadData()
    }
    
    func loadData() {
        for i in 0..<10 {
            categories.append(CategoryModel.getTestModel(i))
        }
        reloadData?()
    }
    
    func cellDidTap(at indexPath: IndexPath) {
        if indexPath.section == 1 {
            delegate?.categoryViewModelCreateCategory()
        } else {
            chosenCategory = categories[indexPath.row]
            delegate?.categoryViewModelValueChanged(chosenCategory)
        }
    }
    
    func closeButtonDidTap() {
        delegate?.categoryViewModelCloseButtonDidTap()
    }
}
