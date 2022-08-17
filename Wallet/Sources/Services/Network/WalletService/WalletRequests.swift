//
//  WalletRequests.swift
//  Wallet
//

import Foundation

final class WalletRequestsFactory {
    private static let basePath = "/wallet"
    
    static func makeGetRequest(walletId: Int, personId: Int) -> DefaultSimpleRequest<WalletApiModel> {
        DefaultSimpleRequest<WalletApiModel>(
            httpMethod: .GET,
            path: "\(basePath)/\(walletId)",
            queryParameters: ["person_id": "\(personId)"]
        )
    }
    
    static func makeGetAllReqeust(personId: Int) -> DefaultSimpleRequest<[WalletModel]> {
        DefaultSimpleRequest<[WalletModel]>(
            httpMethod: .GET,
            path: basePath,
            queryParameters: ["person_id": "\(personId)"]
        )
    }
    
    static func makeCreateReqeust(personId: Int, wallet: WalletApiModel) -> DefaultBodyRequest<WalletApiModel, WalletApiModel> {
        DefaultBodyRequest<WalletApiModel, WalletApiModel>(
            httpMethod: .POST,
            path: basePath,
            queryParameters: ["person_id": "\(personId)"],
            headers: nil,
            body: wallet
        )
    }
    
    static func makeUpdateReqeust(walletId: Int, personId: Int, wallet: WalletApiModel) -> DefaultBodyRequest<WalletApiModel, WalletApiModel> {
        DefaultBodyRequest<WalletApiModel, WalletApiModel>(
            httpMethod: .POST,
            path: "\(basePath)/\(walletId)",
            queryParameters: ["person_id": "\(personId)"],
            headers: nil,
            body: wallet
        )
    }
    
    static func makeDeleteRequest(walletId: Int, personId: Int) -> DefaultSimpleRequest<WalletApiModel> {
        DefaultSimpleRequest<WalletApiModel>(
            httpMethod: .DELETE,
            path: "\(basePath)/\(walletId)",
            queryParameters: ["person_id": "\(personId)"]
        )
    }
}
