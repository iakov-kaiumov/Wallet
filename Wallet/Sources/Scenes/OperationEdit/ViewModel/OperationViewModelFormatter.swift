//
//  OperationViewModelFormatter.swift
//  Wallet
//

import Foundation

protocol IOperationViewModelFormatter {
    func formatAmount(_ operation: OperationModel?) -> String
    func formatType(_ operation: OperationModel?) -> String
    func formatCategory(_ operation: OperationModel?) -> String
    func formatDate(_ operation: OperationModel?) -> String
}

final class OperationViewModelFormatter: IOperationViewModelFormatter {
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()
    
    func formatAmount(_ operation: OperationModel?) -> String {
        guard let amount = operation?.operationBalance else {
            return ""
        }
        return amount.displayString()
    }
    
    func formatType(_ operation: OperationModel?) -> String {
        guard let type = operation?.type else {
            return ""
        }
        switch type {
        case .INCOME:
            return R.string.localizable.operation_type_income()
        case .SPENDING:
            return R.string.localizable.operation_type_spending()
        }
    }
    
    func formatCategory(_ operation: OperationModel?) -> String {
        guard let category = operation?.category else {
            return ""
        }
        return category.name ?? ""
    }
    
    func formatDate(_ operation: OperationModel?) -> String {
        guard let date = operation?.operationDate else {
            return ""
        }
        return dateFormatter.string(from: date)
    }
}