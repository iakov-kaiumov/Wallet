//
//  CurrencyApiModel.swift
//  Wallet
//

import Foundation

struct CurrencyApiModel: Codable {
    let code: String
    let symbol: String
    let fullDescription: String
    let shortDescription: String
    let value: Double
    let ascending: Bool
}
