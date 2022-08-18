//
//  Decimal+DisplayString.swift
//  Wallet
//

import Foundation

extension Decimal {
    func displayString(currency: CurrencyModel? = nil) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        let string = formatter.string(from: self as NSNumber) ?? ""
        if let currency = currency {
            return string + " " + currency.symbol
        }
        return string
    }
}
