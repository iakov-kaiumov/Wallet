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
struct OperationApiModelToSend: Codable {
    let type: MoneyOperationType?
    let balance: Decimal?
    let categoryId: Int?
    let date: Date?
}
