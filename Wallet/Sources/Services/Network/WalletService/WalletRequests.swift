//
//  WalletRequests.swift
//  Wallet
//

import Foundation

final class WalletRequestsFactory {
    private static let basePath = "/wallet"
    
    static func makeGetRequest(walletId: Int) -> DefaultSimpleRequest<WalletApiModel> {
        DefaultSimpleRequest<WalletApiModel>(
            httpMethod: .GET,
            path: "\(basePath)/\(walletId)"
        )
    }
    
    static func makeGetAllReqeust() -> DefaultSimpleRequest<[WalletApiModel]> {
        DefaultSimpleRequest<[WalletApiModel]>(
            httpMethod: .GET,
            path: basePath
        )
    }
    
    static func makeCreateReqeust(wallet: WalletApiModelShort) -> DefaultBodyRequest<WalletApiModelShort, WalletApiModelShort> {
        DefaultBodyRequest<WalletApiModelShort, WalletApiModelShort>(
            httpMethod: .POST,
            path: basePath,
            queryParameters: [:],
            headers: nil,
            body: wallet
        )
    }
    
    static func makeUpdateReqeust(walletId: Int, wallet: WalletApiModelShort) -> DefaultBodyRequest<WalletApiModelShort, WalletApiModelShort> {
        DefaultBodyRequest<WalletApiModelShort, WalletApiModelShort>(
            httpMethod: .PUT,
            path: "\(basePath)/\(walletId)",
            queryParameters: [:],
            headers: nil,
            body: wallet
        )
    }
    
    static func makeDeleteRequest(walletId: Int) -> DefaultSimpleRequest<EmptyBody> {
        DefaultSimpleRequest<EmptyBody>(
            httpMethod: .DELETE,
            path: "\(basePath)/\(walletId)"
        )
    }
}
