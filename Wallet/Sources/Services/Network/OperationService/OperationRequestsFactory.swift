//
//  OperationRequests.swift
//  Wallet
//

import Foundation

final class OperationRequestsFactory {
    private static let basePath = "/wallet"
    
    static func makeGetRequest(walletId: Int, operationId: Int) -> DefaultSimpleRequest<OperationApiModel> {
        DefaultSimpleRequest<OperationApiModel>(
            httpMethod: .GET,
            path: "\(basePath)/\(walletId)/operation/\(operationId)"
        )
    }
    
    static func makeGetAllRequest(walletId: Int) -> DefaultSimpleRequest<[OperationApiModel]> {
        DefaultSimpleRequest<[OperationApiModel]>(
            httpMethod: .GET,
            path: "\(basePath)/\(walletId)/operation"
        )
    }
    
    static func makeCreateReqeust(walletId: Int, operation: OperationApiModelToSend) -> DefaultBodyRequest<OperationApiModel, OperationApiModelToSend> {
        DefaultBodyRequest<OperationApiModel, OperationApiModelToSend>(
            httpMethod: .POST,
            path: "\(basePath)/\(walletId)/operation",
            headers: nil,
            body: operation
        )
    }
    
    static func makeDeleteRequest(walletId: Int, operationId: Int) -> some IRequest {
        DefaultSimpleRequest<CategoryApiModel>(
            httpMethod: .DELETE,
            path: "\(basePath)/\(walletId)/operation/\(operationId)"
        )
    }
}
