//
//  CurrenciesRequests.swift
//  Wallet
//

import Foundation

final class CurrenciesRequestsFactory {
    private static let basePath = "/currency"
    
    static func makeGetAllRequest() -> DefaultSimpleRequest<[CurrencyApiModel]> {
        DefaultSimpleRequest<[CurrencyApiModel]>(
            httpMethod: .GET,
            path: basePath
        )
    }
    
    static func makeGetDailyRequest() -> DefaultSimpleRequest<[CurrencyApiModel]> {
        DefaultSimpleRequest<[CurrencyApiModel]>(
            httpMethod: .GET,
            path: "\(basePath)/daily"
        )
    }
}
