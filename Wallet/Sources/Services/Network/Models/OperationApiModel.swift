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
    
    var operationModel: OperationModel? {
        guard let id = id,
              let walletId = walletId,
              let type = type,
              let category = categoryDto?.categoryModel,
              let balance = balance,
              let date = date else { return nil }
        return OperationModel(id: id,
                              walletId: walletId,
                              operationBalance: balance,
                              operationDate: date,
                              type: type,
                              category: category)

    }
}
