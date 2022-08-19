//
//  CDCurrency+Transient.swift
//  Wallet
//

import Foundation

extension CDCurrency: Persistent {
    func makeTransient() -> CurrencyModel? {
        guard let code = code,
              let symbol = symbol,
              let fullDescription = full_description,
              let shortDescription = short_description,
              let value = value?.decimalValue else { return nil }
        return CurrencyModel(code: code,
                             symbol: symbol,
                             fullDescription: fullDescription,
                             shortDescription: shortDescription,
                             value: value,
                             isAscending: isAscending)
    }
}
