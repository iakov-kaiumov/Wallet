//
// WalletApiModel.swift
//

import Foundation

 struct WalletApiModel: Codable {
    let id: Int
    let name: String
    let currency: String?
    let amountLimit: Decimal?
    let balance: Decimal?
    let income: Decimal?
    let spendings: Decimal?
    let isHidden: Bool?
 }
