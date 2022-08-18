//
// OperationApiModel.swift
//

import Foundation

public struct OperationApiModel: Codable {

    public enum ModelType: String, Codable { 
        case income = "INCOME"
        case spending = "SPENDING"
    }
    public var id: Int?
    public var walletId: Int?
    public var type: ModelType?
    /** Категория операции */
    public var categoryId: Int64?
    public var balance: Decimal?
    public var date: Date?
}
