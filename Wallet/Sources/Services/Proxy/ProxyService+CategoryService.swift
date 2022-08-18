//
//  ProxyService+CategoryService.swift
//  Wallet
//

import Foundation

extension ProxyService: CategoryServiceProtocol {
    func categoryNetworkServiceGetAll(personId: Int, type: CategoryApiModel.CategoryType, completion: @escaping (Result<[CategoryApiModel], NetworkError>) -> Void) {
        // TODO: - Cache request
        networkService.categoryNetworkServiceGetAll(personId: personId,
                                                    type: type,
                                                    completion: completion)
    }
    
    func categoryNetworkServiceCreate(_ category: CategoryApiModel,
                                      completion: @escaping (Result<CategoryApiModel, NetworkError>) -> Void) {
        // TODO: - Cache request
        networkService.categoryNetworkServiceCreate(category, completion: completion)
    }
    
}
