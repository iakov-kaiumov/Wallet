//
//  NewCategoryViewModelFormatter.swift
//  Wallet
//

import Foundation

protocol INewCategoryViewModelFormatter {
    func formatName(_ category: CategoryModel?) -> String
    func formatType(_ category: CategoryModel?) -> String
}

final class NewCategoryViewModelFormatter: INewCategoryViewModelFormatter {
    func formatName(_ category: CategoryModel?) -> String {
        return category?.name ?? ""
    }
    
    func formatType(_ category: CategoryModel?) -> String {
        guard let type = category?.type else {
            return ""
        }
        switch type {
        case .INCOME:
            return R.string.localizable.operation_type_income()
        case .SPENDING:
            return R.string.localizable.operation_type_spending()
        }
    }
}
