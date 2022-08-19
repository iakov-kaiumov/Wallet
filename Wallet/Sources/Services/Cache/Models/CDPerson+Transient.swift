//
//  CDPerson+Transient.swift
//  Wallet
//

import Foundation

extension CDPerson: Persistent {
    func makeTransient() -> PersonModel? {
        guard let email = email,
              let balance = balance?.decimalValue,
              let income = income?.decimalValue,
              let spendings = spendings?.decimalValue else { return nil }
                
        return PersonModel(id: Int(id),
                           email: email,
                           personBalance: balance,
                           personIncome: income,
                           personSpendings: spendings)
    }
    
}
