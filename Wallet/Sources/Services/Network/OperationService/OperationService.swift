//
//  OperationService.swift
//  Wallet
//

import Foundation

protocol OperationServiceProtocol: AnyObject {
    func operationServiceCreate(_ operation: OperationApiModel,
                                walletID: Int,
                                completion: @escaping (Result<OperationApiModel, NetworkError>) -> Void)
    
    func operationServiceGetAll(walletID: Int, completion: @escaping (Result<[OperationApiModel], NetworkError>) -> Void)
    
    func operationServiceDelete(walletId: Int,
                                operationId: Int,
                                completion: @escaping (Result<Data, NetworkError>) -> Void)
}

extension NetworkService: OperationServiceProtocol {
    func operationServiceDelete(walletId: Int, operationId: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let request = OperationRequestsFactory.makeDeleteRequest(walletId: walletId, operationId: operationId)
        requestProcessor.fetchData(request, completion: completion)
    }
    
    func operationServiceCreate(_ operation: OperationApiModel, walletID: Int, completion: @escaping (Result<OperationApiModel, NetworkError>) -> Void) {
        let request = OperationRequestsFactory.makeCreateReqeust(walletId: walletID, operation: operation)
        requestProcessor.fetch(request, completion: completion)
    }
    
    func operationServiceGetAll(walletID: Int, completion: @escaping (Result<[OperationApiModel], NetworkError>) -> Void) {
        let request = OperationRequestsFactory.makeGetAllRequest(walletId: walletID)
        requestProcessor.fetch(request, completion: completion)
    }
    
}
