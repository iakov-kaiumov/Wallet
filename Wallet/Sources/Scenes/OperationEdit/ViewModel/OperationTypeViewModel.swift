//
//  OperationTypeViewModel.swift
//  Wallet
//

import Foundation

protocol OperationTypeViewModelDelegate: AnyObject {
    func operationTypeViewModelCloseButtonDidTap()
    
    func operationTypeViewModelValueChanged(_ value: OperationType?)
}

final class OperationTypeViewModel {
    var isModal: Bool
    
    var types: [OperationType] = OperationType.allCases
    
    var chosenType: OperationType = .INCOME
    
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
