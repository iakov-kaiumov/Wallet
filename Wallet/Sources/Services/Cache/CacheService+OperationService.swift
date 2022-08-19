//
//  CacheService+OperationService.swift
//  Wallet
//

import Foundation

protocol OperationCacheServiceProtocol: AnyObject {
    func getOperations(for walletId: Int) -> [OperationModel]
    func setOperations(_ operations: [OperationModel], for walletId: Int) throws
    func deleteOperation(_ operationId: Int) throws
}

extension CacheService: OperationCacheServiceProtocol {
    func getOperations(for walletId: Int) -> [OperationModel] {
        let operations = getObjectsByValue(columnName: #keyPath(CDOperation.wallletId),
                                           value: String(walletId),
                                           objectType: CDOperation.self,
                                           context: readContext)
        let converted = operations.compactMap { $0.makeTransient() }
        return converted
    }
    
    func setOperations(_ operations: [OperationModel], for walletId: Int) throws {
        operations.forEach { model in
            _ = model.makePersistent(context: writeContext)
        }
        try? saveWriteContext()
    }
    
    func deleteOperation(_ operationId: Int) throws {
        try? deleteObjectsByValue(columnName: "id",
                                  value: String(operationId),
                                  objectType: CDOperation.self)
    }
}
