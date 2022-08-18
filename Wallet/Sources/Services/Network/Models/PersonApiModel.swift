//
// PersonApiModel.swift
//

import Foundation

public struct PersonApiModel: Codable {
    public var id: Int64?
    public var email: String?
    public var balance: Decimal?
    public var income: Decimal?
    public var spendings: Decimal?
}
