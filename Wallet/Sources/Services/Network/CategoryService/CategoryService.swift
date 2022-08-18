//
//  CategoryService.swift
//  Wallet
//

import Foundation

protocol CategoryServiceProtocol: AnyObject {
    func categoryNetworkServiceGetAll(personId: Int,
                                      type: CategoryApiModel.CategoryType,
                                      completion: @escaping (Result<[CategoryApiModel], NetworkError>) -> Void)
    
    func categoryNetworkServiceCreate(_ category: CategoryApiModel,
                                      personId: Int,
                                      type: CategoryApiModel.CategoryType,
                                      completion: @escaping (Result<CategoryApiModel, NetworkError>) -> Void)
}

extension NetworkService: CategoryServiceProtocol {
    func categoryNetworkServiceGetAll(
        personId: Int,
        type: CategoryApiModel.CategoryType,
        completion: @escaping (Result<[CategoryApiModel], NetworkError>) -> Void
    ) {
        let request = CategoryRequestsFactory.makeGetRequest(personId: personId, categoryType: type)
        requestProcessor.fetch(request) { result in
            completion(result)
        }
    }
    
    func categoryNetworkServiceCreate(_ category: CategoryApiModel,
                                      personId: Int,
                                      type: CategoryApiModel.CategoryType,
                                      completion: @escaping (Result<CategoryApiModel, NetworkError>) -> Void) {
        let request = CategoryRequestsFactory.makeCreateReqeust(category: category)
        requestProcessor.fetch(request, completion: completion)
    }
}