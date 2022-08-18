//
//  Decimal+DisplayString.swift
//  Wallet
//

import Foundation

extension Decimal {
    func displayString(currency: CurrencyModel = .RUB) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        let string = formatter.string(from: self as NSNumber) ?? ""
        return string + " " + currency.symbol
    }
}
