//
//  PersonRequests.swift
//  Wallet
//

import Foundation

final class PersonRequestsFactory {
    private static let basePath = "/person"
    
    static func makeGetRequest() -> DefaultSimpleRequest<PersonApiModel> {
        DefaultSimpleRequest<PersonApiModel>(httpMethod: .GET, path: basePath)
    }
    
    static func makeCreateReqeust(person: PersonApiModel) -> DefaultBodyRequest<PersonApiModel, PersonApiModel> {
        DefaultBodyRequest<PersonApiModel, PersonApiModel>(
            httpMethod: .POST,
            path: basePath,
            queryParameters: [:],
            headers: nil,
            body: person
        )
    }
    
    static func makeDeleteRequest() -> DefaultSimpleRequest<PersonApiModel> {
        DefaultSimpleRequest<PersonApiModel>(httpMethod: .DELETE, path: basePath)
    }
}
