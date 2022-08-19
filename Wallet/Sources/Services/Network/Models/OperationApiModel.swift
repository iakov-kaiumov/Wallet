//
// OperationApiModel.swift
//

import Foundation

struct OperationApiModel: Codable {
    let id: Int?
    let walletId: Int?
    let type: MoneyOperationType?
    /** Категория операции */
    let categoryDto: CategoryApiModel?
    let balance: Decimal?
    let date: Date?
}
