//
//  DefaultNetworkSettings.swift
//  Wallet
//

import Foundation

struct DefaultNetworkSettings {
    static let baseUrl: String = "http://34.88.156.80:9090"
}

final class DefaultSimpleRequest<Model: Decodable>: SimpleRequest<Model> {
    init(
        httpMethod: HTTPMethod,
        path: String,
        queryParameters: [String: String] = [:],
        headers: [String: String]? = nil
    ) {
        super.init(
            httpMethod: httpMethod,
            baseUrlString: DefaultNetworkSettings.baseUrl,
            path: path,
            queryParameters: queryParameters,
            headers: headers
        )
    }
}

final class DefaultBodyRequest<Model: Decodable, Body: Encodable>: BodyRequest<Model, Body> {
    init(
        httpMethod: HTTPMethod,
        path: String,
        queryParameters: [String: String] = [:],
        headers: [String: String]? = nil,
        body: Body? = nil
    ) {
        super.init(
            httpMethod: httpMethod,
            baseUrlString: DefaultNetworkSettings.baseUrl,
            path: path,
            queryParameters: queryParameters,
            headers: headers,
            body: body
        )
    }
}
