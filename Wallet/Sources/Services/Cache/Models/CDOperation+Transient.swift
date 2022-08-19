//
//  CDOperation+Transient.swift
//  Wallet
//

import Foundation

extension CDOperation: Persistent {
    func makeTransient() -> OperationModel? {
        guard let date = date,
              let type = MoneyOperationType(rawValue: type ?? ""),
              let category = category else { return nil }
                
        return OperationModel(id: Int(id),
                              walletId: Int(wallletId),
                              operationBalance: balance?.decimalValue,
                              operationDate: date,
                              type: type,
                              category: category.makeTransient())
    }
    
}
