//
//  CurrencyModel.swift
//  Wallet
//

import Foundation

struct CurrencyModel: Codable {
    var type: CurrencyType
    var isOn: Bool
    var isMain: Bool
}
