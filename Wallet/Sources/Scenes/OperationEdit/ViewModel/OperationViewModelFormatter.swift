//
//  OperationViewModelFormatter.swift
//  Wallet
//

import Foundation

protocol IOperationViewModelFormatter {
    func formatAmount(_ value: Double?) -> String
    func formatType(_ value: OperationType?) -> String
    func formatCategory(_ value: CategoryModel?) -> String
    func formatDate(_ value: Date?) -> String
}

final class OperationViewModelFormatter: IOperationViewModelFormatter {
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()
    
    func formatAmount(_ value: Double?) -> String {
        guard let value = value else {
            return ""
        }
        return String(format: "%.2f", value)
    }
    
    func formatType(_ value: OperationType?) -> String {
        guard let value = value else {
            return ""
        }
        return value.rawValue
    }
    
    func formatCategory(_ value: CategoryModel?) -> String {
        guard let value = value else {
            return ""
        }
        return value.name ?? ""
    }
    
    func formatDate(_ value: Date?) -> String {
        guard let value = value else {
            return ""
        }
        return dateFormatter.string(from: value)
    }
}
