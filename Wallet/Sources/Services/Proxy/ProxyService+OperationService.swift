//
//  ProxyService+OperationService.swift
//  Wallet
//

import Foundation

extension ProxyService: OperationServiceProtocol {
    func operationServiceCreate(_ operation: OperationApiModel, walletID: Int, completion: @escaping (Result<OperationApiModel, NetworkError>) -> Void) {
        networkService.operationServiceCreate(operation, walletID: walletID, completion: completion)
    }
    
    func operationServiceGetAll(walletID: Int, completion: @escaping (Result<[OperationApiModel], NetworkError>) -> Void) {
        networkService.operationServiceGetAll(walletID: walletID, completion: completion)
    }
   
    func operationServiceDelete(walletId: Int, operationId: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        networkService.operationServiceDelete(walletId: walletId, operationId: operationId, completion: completion)
    }
}
