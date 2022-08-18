//
// CategoryApiModel.swift
//

import Foundation

public struct CategoryApiModel: Codable {
    public enum CategoryType: String, Codable {
        case income = "INCOME"
        case spending = "SPENDING"
    }
    public var id: Int64?
    public var name: String
    public var type: CategoryType?
    public var color: String
    public var iconId: Int64?
}
