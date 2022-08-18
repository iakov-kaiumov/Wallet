//
//  ProxyService+OperationService.swift
//  Wallet
//

import Foundation

extension ProxyService: OperationServiceProtocol {
    func operationServiceCreate(_ operation: OperationApiModel, walletID: Int, completion: @escaping (Result<OperationModel, NetworkError>) -> Void) {
        networkService.operationServiceCreate(operation, walletID: walletID, completion: completion)
    }
    
    func operationServiceGetAll(walletID: Int, completion: @escaping (Result<[OperationModel], NetworkError>) -> Void) {
        networkService.operationServiceGetAll(walletID: walletID, completion: completion)
    }
   
}
