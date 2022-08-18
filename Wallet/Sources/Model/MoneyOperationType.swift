//
//  MoneyOperationType.swift
//  Wallet
//

import Foundation

enum MoneyOperationType: String, Codable, CaseIterable {
    case INCOME, SPENDING
    
    func displayName() -> String {
        switch self {
        case .INCOME:
            return "Пополнение"
        case .SPENDING:
            return "Траты"
        }
    }
    
    func convertToCategoryType() -> CategoryApiModel.CategoryType {
        switch self {
        case .INCOME:
            return CategoryApiModel.CategoryType.income
        case .SPENDING:
            return CategoryApiModel.CategoryType.spending
        }
    }
}
