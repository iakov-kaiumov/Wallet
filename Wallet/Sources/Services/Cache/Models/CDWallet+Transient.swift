//
//  CDWallet+Transient.swift
//  Wallet
//

import Foundation

extension CDWallet: Persistent {
    func makeTransient() -> WalletModel? {
        guard let name = name,
              let currency = currency?.makeTransient(),
              let balance = balance?.decimalValue,
              let income = income?.decimalValue,
              let spendings = spendings?.decimalValue else { return nil }
                
        return WalletModel(id: Int(id),
                           name: name,
                           currency: currency,
                           limit: amountLimit?.decimalValue,
                           balance: balance,
                           income: income,
                           spendings: spendings,
                           isHidden: isHidden)
    }

}
