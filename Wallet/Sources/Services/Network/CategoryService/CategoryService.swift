//
//  CategoryService.swift
//  Wallet
//

import Foundation

protocol CategoryServiceProtocol: AnyObject {
    func categoryNetworkServiceGetAll(type: MoneyOperationType,
                                      completion: @escaping (Result<[CategoryApiModel], NetworkError>) -> Void)
    
    func categoryNetworkServiceCreate(_ category: CategoryApiModel,
                                      completion: @escaping (Result<CategoryApiModel, NetworkError>) -> Void)
}

extension NetworkService: CategoryServiceProtocol {
    func categoryNetworkServiceGetAll(type: MoneyOperationType, completion: @escaping (Result<[CategoryApiModel], NetworkError>) -> Void) {
        let request = CategoryRequestsFactory.makeGetRequest(categoryType: type)
        requestProcessor.fetch(request) { result in
            completion(result)
        }
    }
    
    func categoryNetworkServiceCreate(_ category: CategoryApiModel,
                                      completion: @escaping (Result<CategoryApiModel, NetworkError>) -> Void) {
        let request = CategoryRequestsFactory.makeCreateRequest(category: category)
        requestProcessor.fetch(request, completion: completion)
    }
}
