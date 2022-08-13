//
//  URLConstructor.swift
//  Wallet
//

import Foundation

protocol IURLConstructor: AnyObject {
    func construct<T: IRequest>(from request: T) throws -> URL
}

final class URLConstructor: IURLConstructor {
    func construct<T: IRequest>(from request: T) throws -> URL {
        guard var components = URLComponents(string: request.baseUrlString) else {
            throw URLConstructorError.invalidBaseUrl
        }
        components.path = request.path
        components.queryItems = request.queryParameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let url = components.url else {
            throw URLConstructorError.urlCreationFailed
        }
        return url
    }
}

enum URLConstructorError: Error {
    case invalidBaseUrl
    case urlCreationFailed
    
    var localizedDescription: String {
        switch self {
        case .invalidBaseUrl:
            return ""
        case .urlCreationFailed:
            return ""
        }
    }
}
