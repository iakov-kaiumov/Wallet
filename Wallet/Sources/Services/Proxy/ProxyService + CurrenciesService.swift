//
//  ProxyService + CurrenciesService.swift
//  Wallet
//

import Foundation

extension ProxyService: CurrenciesServiceProtocol {
    
    func currenciesServiceGetAll(completion: @escaping (Result<[CurrencyApiModel], NetworkError>) -> Void) {
        networkService.currenciesServiceGetAll(completion: completion)
    }
    
    func currenciesServiceGetDaily(completion: @escaping (Result<[CurrencyApiModel], NetworkError>) -> Void) {
        networkService.currenciesServiceGetDaily(completion: completion)
    }
}
