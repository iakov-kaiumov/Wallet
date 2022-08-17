//
// WalletApiModel.swift
//

import Foundation

public struct WalletApiModel: Codable {
    public var id: Int64?
    public var personId: Int64?
    public var name: String
    public var currency: String?
    public var amountLimit: Decimal?
    public var balance: Decimal?
    public var income: Decimal?
    public var spendings: Decimal?
}
