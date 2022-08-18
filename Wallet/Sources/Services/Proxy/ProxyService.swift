//
//  ProxyService.swift
//  Wallet
//

import Foundation

final class ProxyService {
    let networkService: NetworkService
    let cacheService: CacheService
    
    init(networkService: NetworkService, cacheService: CacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
}
