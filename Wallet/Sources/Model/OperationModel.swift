//
//  OperationModel.swift
//  Wallet
//

import Foundation
import CoreData

struct OperationModel: Codable, Transient {
    var id: Int
    
    var walletId: Int
    
    var operationBalance: Decimal?
    
    var operationDate: Date
    
    var type: MoneyOperationType?
    
    var category: CategoryModel?
    
    func makeApiModel() -> OperationApiModel {
        OperationApiModel(id: id,
                          walletId: walletId,
                          type: type,
                          categoryDto: category?.makeApiModel(),
                          balance: operationBalance,
                          date: operationDate)
    }
    
    func makePersistent(context: NSManagedObjectContext) -> CDOperation? {
        let operation = CDOperation(context: context)
        operation.id = Int64(id)
        operation.wallletId = Int64(walletId)
        if let operationBalance = operationBalance {
            operation.balance = NSDecimalNumber(decimal: operationBalance)
        }
        operation.type = type?.rawValue
        operation.category = category?.makePersistent(context: context)
        operation.date = operationDate
        return operation
        
    }
    
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
            operationDate: apiModel.date ,
            type: apiModel.type,
            category: apiModel.categoryDto?.categoryModel
        )
    }
}
