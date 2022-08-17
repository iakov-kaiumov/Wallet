//
//  OperationModel.swift
//  Wallet
//

import Foundation

struct OperationModel: Codable {
    var id: Int
    
    var walletId: Int
    
    var operationBalance: Decimal?
    
    var operationDate: Date?
    
    var type: MoneyOperationType?
    
    var category: CategoryModel?
    
    static func makeTestModel(_ id: Int = 0) -> OperationModel {
        return OperationModel(
            id: id,
            walletId: 0,
            operationBalance: Decimal(Double.random(in: 100...10000)),
            operationDate: Date(),
            type: Bool.random() ? MoneyOperationType.INCOME : MoneyOperationType.SPENDING,
            category: CategoryModel.makeTestModel()
        )
    }
}
