//
//  OperationModel.swift
//  Wallet
//

import Foundation

struct OperationModel: Codable {
    var id: Int
    
    var walletId: Int
    
    var operationBalance: Decimal?
    
    var operationDate: Date
    
    var type: MoneyOperationType?
    
    var category: CategoryModel?
    
}

extension OperationModel {
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
    
    static func makeEmptyModel(_ id: Int = 0) -> OperationModel {
        return OperationModel(
            id: id,
            walletId: 0,
            operationBalance: nil,
            operationDate: Date(),
            type: nil,
            category: nil
        )
    }
    
    static func fromApiModel(_ apiModel: OperationApiModel) -> OperationModel? {
        guard let id = apiModel.id, let walletId = apiModel.walletId else {
            return nil
        }
        return OperationModel(
            id: id,
            walletId: walletId,
            operationBalance: apiModel.balance,
            operationDate: apiModel.date ?? Date(),
            type: apiModel.type,
            category: apiModel.categoryDto?.categoryModel
        )
    }
}
