//
//  ProxyService+OperationService.swift
//  Wallet
//

import Foundation

extension ProxyService: OperationServiceProtocol {
    func addDelegate(_ delegate: OperationServiceDelegate) {
        networkService.addDelegate(delegate)
    }
    
    func operationServiceCreate(_ operation: OperationApiModelToSend, walletID: Int, completion: @escaping (Result<OperationApiModel, NetworkError>) -> Void) {
        networkService.operationServiceCreate(operation, walletID: walletID) { [weak self] result in
            completion(result)
            
            guard let self = self else {
                return
            }
            self.networkService.operationServiceGetAll(walletID: walletID, completion: self.notifyOperationDelegates)
            
            self.walletServiceGetAll(completion: {_ in })
            
            self.personServiceGet(completion: { _ in })
        }
    }
    
    func operationServiceGetAll(walletID: Int, completion: @escaping (Result<[OperationApiModel], NetworkError>) -> Void) {
        networkService.operationServiceGetAll(walletID: walletID, completion: completion)
    }
    
    func operationServiceDelete(walletId: Int, operationId: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        networkService.operationServiceDelete(walletId: walletId, operationId: operationId) { result in
            completion(result)
            
            self.walletServiceGetAll(completion: {_ in })
            
            self.personServiceGet(completion: { _ in })
        }
    }
    
    private func notifyOperationDelegates(result: Result<[OperationApiModel], NetworkError>) {
        switch result {
        case .success(let operations):
            self.networkService.operationDelegates.forEach {
                $0.operationService(self, didLoadOperations: operations)
            }
        case .failure:
            break
        }
    }
}
