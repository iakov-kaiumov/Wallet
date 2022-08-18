//
//  CurrenciesService.swift
//  Wallet
//

import Foundation

protocol CurrenciesServiceProtocol: AnyObject {
    func currenciesServiceGetAll(completion: @escaping (Result<[CurrencyApiModel], NetworkError>) -> Void)
    
    func currenciesServiceGetDaily(completion: @escaping (Result<[CurrencyApiModel], NetworkError>) -> Void)
}

extension NetworkService: CurrenciesServiceProtocol {
    func currenciesServiceGetAll(completion: @escaping (Result<[CurrencyApiModel], NetworkError>) -> Void) {
        let request = CurrenciesRequestsFactory.makeGetAllRequest()
        requestProcessor.fetch(request, completion: completion)
    }
    
    func currenciesServiceGetDaily(completion: @escaping (Result<[CurrencyApiModel], NetworkError>) -> Void) {
        let request = CurrenciesRequestsFactory.makeGetDailyRequest()
        requestProcessor.fetch(request, completion: completion)
    }
}
