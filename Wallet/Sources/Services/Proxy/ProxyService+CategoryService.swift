//
//  ProxyService+CategoryService.swift
//  Wallet
//

import Foundation

extension ProxyService: CategoryServiceProtocol {
    func categoryNetworkServiceGetAll(personId: Int, type: MoneyOperationType, completion: @escaping (Result<[CategoryApiModel], NetworkError>) -> Void) {
        // TODO: - Cache request
        networkService.categoryNetworkServiceGetAll(type: type, completion: completion)
    }
    
    func categoryNetworkServiceCreate(_ category: CategoryApiModel,
                                      personId: Int,
                                      type: MoneyOperationType,
                                      completion: @escaping (Result<CategoryApiModel, NetworkError>) -> Void) {
        // TODO: - Cache request
        networkService.categoryNetworkServiceCreate(category, completion: completion)
    }
    
}
