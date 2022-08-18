//
//  OperationService.swift
//  Wallet
//

import Foundation

protocol OperationServiceProtocol: AnyObject {
    func operationServiceCreate(_ operation: OperationApiModel,
                                walletID: Int,
                                completion: @escaping (Result<OperationModel, NetworkError>) -> Void)
    
    func operationServiceGetAll(walletID: Int, completion: @escaping (Result<[OperationModel], NetworkError>) -> Void)
}

extension NetworkService: OperationServiceProtocol {
    func operationServiceCreate(_ operation: OperationApiModel, walletID: Int, completion: @escaping (Result<OperationModel, NetworkError>) -> Void) {
        let request = OperationRequestsFactory.makeCreateReqeust(walletId: walletID, operation: operation)
        requestProcessor.fetch(request) { result in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func operationServiceGetAll(walletID: Int, completion: @escaping (Result<[OperationModel], NetworkError>) -> Void) {
        let request = OperationRequestsFactory.makeGetAllRequest(walletId: walletID)
        requestProcessor.fetch(request) { result in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
