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
}
