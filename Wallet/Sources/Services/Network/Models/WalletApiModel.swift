//
// WalletApiModel.swift
//

import Foundation

struct WalletApiModel: Codable {
    let id: Int64?
    let isHidden: Int?
    let name: String
    let currency: String? 
    let amountLimit: Decimal?
}

// struct WalletApiModel: Codable {
//    let id: Int64?
//    let name: String
//    let currency: String?
//    let amountLimit: Decimal?
//    let balance: Decimal?
//    let income: Decimal?
//    let spendings: Decimal?
//    let isHidden: Bool?
// }
