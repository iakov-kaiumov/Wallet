//
//  CategoryTypeViewModel.swift
//  Wallet
//

import Foundation

protocol CategoryTypeViewModelDelegate: AnyObject {
    func categoryTypeViewModelCloseButtonDidTap()
    
    func categoryTypeViewModelValueChanged(_ value: MoneyOperationType?)
}

final class CategoryTypeViewModel {
    var isModal: Bool
    
    var types: [MoneyOperationType] = MoneyOperationType.allCases
    
    var chosenType: MoneyOperationType = .INCOME
    
    weak var delegate: CategoryTypeViewModelDelegate?
    
    init(isModal: Bool) {
        self.isModal = isModal
    }
    
    func closeButtonDidTap() {
        delegate?.categoryTypeViewModelValueChanged(chosenType)
        delegate?.categoryTypeViewModelCloseButtonDidTap()
    }
    
    func onTypeChanged() {
        delegate?.categoryTypeViewModelValueChanged(chosenType)
    }
}
