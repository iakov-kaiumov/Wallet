//
//  OperationRequests.swift
//  Wallet
//

import Foundation

final class OperationRequests {
    private static let basePath = "/wallet"
    
    static func makeGetRequest(walletId: Int, operationId: Int) -> some IRequest {
        DefaultSimpleRequest<OperationApiModel>(
            httpMethod: .GET,
            path: "\(basePath)/\(walletId)/operation/\(operationId)"
        )
    }
    
    static func makeGetAllRequest(walletId: Int) -> some IRequest {
        DefaultSimpleRequest<OperationApiModel>(
            httpMethod: .GET,
            path: "\(basePath)/\(walletId)/operation"
        )
    }
    
    static func makeCreateReqeust(walletId: Int, operation: OperationApiModel) -> some IRequest {
        DefaultBodyRequest<OperationApiModel, OperationApiModel>(
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
