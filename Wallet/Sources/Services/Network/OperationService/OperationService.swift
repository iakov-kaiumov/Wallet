//
//  OperationService.swift
//  Wallet
//

import Foundation

protocol OperationServiceDelegate: AnyObject {
    func operationService(_ service: OperationServiceProtocol, didLoadOperations operations: [OperationApiModel])
}

protocol OperationServiceProtocol: AnyObject {
    func addDelegate(_ delegate: OperationServiceDelegate)
    
    func operationServiceCreate(_ operation: OperationApiModelToSend,
                                walletID: Int,
                                completion: @escaping (Result<OperationApiModel, NetworkError>) -> Void)
    
    func operationServiceGetAll(walletID: Int, completion: @escaping (Result<[OperationApiModel], NetworkError>) -> Void)
    
    func operationServiceDelete(walletId: Int,
                                operationId: Int,
                                completion: @escaping (Result<Data, NetworkError>) -> Void)
}

extension NetworkService: OperationServiceProtocol {
    func addDelegate(_ delegate: OperationServiceDelegate) {
        operationDelegates.addDelegate(delegate)
    }
    
    func operationServiceDelete(walletId: Int, operationId: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let request = OperationRequestsFactory.makeDeleteRequest(walletId: walletId, operationId: operationId)
        requestProcessor.fetchData(request, completion: completion)
    }
    
    func operationServiceCreate(_ operation: OperationApiModelToSend, walletID: Int, completion: @escaping (Result<OperationApiModel, NetworkError>) -> Void) {
        let request = OperationRequestsFactory.makeCreateReqeust(walletId: walletID, operation: operation)
        requestProcessor.fetch(request, completion: completion)
    }
    
    func operationServiceGetAll(walletID: Int, completion: @escaping (Result<[OperationApiModel], NetworkError>) -> Void) {
        let request = OperationRequestsFactory.makeGetAllRequest(walletId: walletID)
        requestProcessor.fetch(request, completion: completion)
    }
    
}
