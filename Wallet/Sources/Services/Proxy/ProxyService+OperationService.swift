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
        guard networkService.internetChecker?.connection != .unavailable else {
            let operations = getOperations(walletId: walletID)
            completion(.success(operations))
            self.notifyOperationDelegates(result: .success(operations))
            return
        }
        
        networkService.operationServiceGetAll(walletID: walletID) { result in
            switch result {
            case .success(let models):
                print(models)
            case .failure(let error):
                print(error)
                let operations = self.getOperations(walletId: walletID)
                completion(.success(operations))
                self.notifyOperationDelegates(result: .success(operations))
                return
            }
            completion(result)
            
            self.notifyOperationDelegates(result: result)
        }
    }
    
    private func getOperations(walletId: Int) -> [OperationApiModel] {
        let operations = cacheService.getOperations(for: walletId)
        let converted = operations.map { $0.makeApiModel() }
        return converted
    }
   
    func operationServiceDelete(walletId: Int, operationId: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        networkService.operationServiceDelete(walletId: walletId, operationId: operationId) { result in
            completion(result)
            
            self.walletServiceGetAll(completion: { _ in })
            self.personServiceGet(completion: { _ in })
        }
    }
    
    private func notifyOperationDelegates(result: Result<[OperationApiModel], NetworkError>) {
        switch result {
        case .success(let operations):
            let converted = operations.compactMap { OperationModel.fromApiModel($0) }
            if let walletId = operations.first?.walletId {
                try? cacheService.setOperations(converted, for: walletId)
            }
            
            self.networkService.operationDelegates.forEach {
                $0.operationService(self, didLoadOperations: operations)
            }
        case .failure:
            break
        }
    }
}
