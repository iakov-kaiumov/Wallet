//
//  OperationTypeViewModel.swift
//  Wallet
//

import Foundation

protocol OperationTypeViewModelDelegate: AnyObject {
    func operationTypeViewModelCloseButtonDidTap()
    
    func operationTypeViewModelValueChanged(_ value: MoneyOperationType?)
}

final class OperationTypeViewModel {
    var isModal: Bool
    
    var types: [MoneyOperationType] = MoneyOperationType.allCases
    
    var chosenType: MoneyOperationType = .INCOME
    
    weak var delegate: OperationTypeViewModelDelegate?
    
    init(isModal: Bool) {
        self.isModal = isModal
    }
    
    func closeButtonDidTap() {
        delegate?.operationTypeViewModelCloseButtonDidTap()
    }
    
    func onTypeChanged() {
        delegate?.operationTypeViewModelValueChanged(chosenType)
    }
}
