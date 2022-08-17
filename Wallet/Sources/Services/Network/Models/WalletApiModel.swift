//
// WalletApiModel.swift
//

import Foundation

public struct WalletApiModel: Codable {
    public var id: Int?
    public var personId: Int?
    public var name: String
    public var currency: String?
    public var amountLimit: Decimal?
    public var balance: Decimal?
    public var income: Decimal?
    public var spendings: Decimal?
}
