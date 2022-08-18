//
//  CategoryRequests.swift
//  Wallet
//

import Foundation

final class CategoryRequestsFactory {
    private static let basePath = "/category"
    
    static func makeGetRequest(id: Int) -> some IRequest {
        DefaultSimpleRequest<CategoryApiModel>(
            httpMethod: .GET,
            path: "\(basePath)/\(id)"
        )
    }
    
    static func makeGetRequest(personId: Int, categoryType: CategoryApiModel.CategoryType) -> DefaultSimpleRequest<[CategoryApiModel]> {
        DefaultSimpleRequest<[CategoryApiModel]>(
            httpMethod: .GET,
            path: basePath,
            queryParameters: [
                "personId": "\(personId)",
                "categoryType": categoryType.rawValue
            ]
        )
    }
    
    static func makeCreateReqeust(category: CategoryApiModel) -> DefaultBodyRequest<CategoryApiModel, CategoryApiModel> {
        DefaultBodyRequest<CategoryApiModel, CategoryApiModel>(
            httpMethod: .POST,
            path: basePath,
            headers: nil,
            body: category
        )
    }
    
    static func makeUpdateReqeust(id: Int, category: CategoryApiModel) -> some IRequest {
        DefaultBodyRequest<CategoryApiModel, CategoryApiModel>(
            httpMethod: .POST,
            path: "\(basePath)/\(id)",
            headers: nil,
            body: category
        )
    }
    
    static func makeDeleteRequest(id: Int) -> some IRequest {
        DefaultSimpleRequest<CategoryApiModel>(
            httpMethod: .DELETE,
            path: "\(basePath)/\(id)"
        )
    }
}
