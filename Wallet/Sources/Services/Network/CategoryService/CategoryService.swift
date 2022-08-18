//
//  CategoryService.swift
//  Wallet
//

import Foundation

protocol CategoryNetworkServiceProtocol: AnyObject {
    func categoryNetworkServiceGetAll(
        personId: Int,
        type: CategoryApiModel.CategoryType,
        completion: @escaping (Result<[CategoryApiModel], NetworkError>) -> Void
    )
}

extension NetworkService: CategoryNetworkServiceProtocol {
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
}
