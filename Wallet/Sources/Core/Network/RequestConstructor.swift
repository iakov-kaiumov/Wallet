//
//  URLRequestConstructor.swift
//  Wallet
//

import Foundation

protocol IRequestConstructor: AnyObject {
    func construct<T: IRequest>(from request: T) throws -> URLRequest
}

final class RequestConstructor: IRequestConstructor {
    func construct<T: IRequest>(from request: T) throws -> URLRequest {
        guard var components = URLComponents(string: request.baseUrlString) else {
            throw RequestConstructorError.invalidBaseUrl
        }
        components.path = request.path
        components.queryItems = request.queryParameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.encodeUrl
        
        guard let url = components.url else {
            throw RequestConstructorError.urlCreationFailed
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        if let body = request.body {
            urlRequest.httpBody = try? JSONEncoder().encode(body)
        }
        request.headers?.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        return urlRequest
    }
}

enum RequestConstructorError: Error {
    case invalidBaseUrl
    case urlCreationFailed
    
    var localizedDescription: String {
        switch self {
        case .invalidBaseUrl:
            return "Incorrect base url"
        case .urlCreationFailed:
            return "Cannot build url"
        }
    }
}
