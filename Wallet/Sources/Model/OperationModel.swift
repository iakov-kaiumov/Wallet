//
//  OperationModel.swift
//  Wallet
//

import Foundation

enum OperationType: String, Codable {
    case INCOME, SPENDING
}

struct OperationModel: Codable {
    var id: Int
    
    var walletId: Int
    
    var operationBalance: Double?
    
    var operationDate: Date?
    
    var type: OperationType?
    
    var category: CategoryModel?
    
    static func getTestModel(_ id: Int = 0) -> OperationModel {
        return OperationModel(
            id: id,
            walletId: 0,
            operationBalance: Double.random(in: 100...10000),
            operationDate: Date(),
            type: Bool.random() ? OperationType.INCOME : OperationType.SPENDING,
            category: CategoryModel.getTestModel()
        )
    }
}
