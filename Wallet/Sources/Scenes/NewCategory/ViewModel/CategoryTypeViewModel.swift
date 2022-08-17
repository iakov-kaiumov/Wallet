//
//  CategoryTypeViewModel.swift
//  Wallet
//

import Foundation

protocol CategoryTypeViewModelDelegate: AnyObject {
    func categoryTypeViewModelCloseButtonDidTap()
    
    func categoryTypeViewModelValueChanged(_ value: CategoryType?)
}

final class CategoryTypeViewModel {
    var isModal: Bool
    
    var types: [CategoryType] = CategoryType.allCases
    
    var chosenType: CategoryType = .INCOME
    
    weak var delegate: CategoryTypeViewModelDelegate?
    
    init(isModal: Bool) {
        self.isModal = isModal
    }
    
    func closeButtonDidTap() {
        delegate?.categoryTypeViewModelCloseButtonDidTap()
    }
    
    func onTypeChanged() {
        delegate?.categoryTypeViewModelValueChanged(chosenType)
    }
}
