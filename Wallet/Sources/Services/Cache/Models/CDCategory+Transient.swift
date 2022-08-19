//
//  CDCategory+Transient.swift
//  Wallet
//

import Foundation

extension CDCategory: Persistent {
    func makeTransient() -> CategoryModel? {
        guard let name = name,
              let type = MoneyOperationType(rawValue: type ?? "") else { return nil }
        return CategoryModel(id: Int(id),
                             name: name,
                             type: type,
                             colorId: Int(colorId),
                             iconId: Int(iconId))
    }
    
}
