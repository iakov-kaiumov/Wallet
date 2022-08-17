//
//  IRequest.swift
//  Wallet
//

import Foundation

struct EmptyBody: Encodable {
    
}

protocol IRequest {
    associatedtype Model: Decodable
    associatedtype Body: Encodable
    var httpMethod: HTTPMethod { get }
    var baseUrlString: String { get }
    var path: String { get }
    var queryParameters: [String: String] { get }
    var headers: [String: String]? { get }
    var body: Body? { get }
}

class SimpleRequest<Model: Decodable>: IRequest {
    init(
        httpMethod: HTTPMethod,
        baseUrlString: String,
        path: String,
        queryParameters: [String: String] = [:],
        headers: [String: String]? = nil
    ) {
        self.httpMethod = httpMethod
        self.baseUrlString = baseUrlString
        self.path = path
        self.queryParameters = queryParameters
        self.headers = headers
    }
    
    var httpMethod: HTTPMethod
    
    var baseUrlString: String
    
    var path: String
    
    var queryParameters: [String: String]
    
    var headers: [String: String]?
    
    var body: EmptyBody?
    
    typealias Model = Model
    
    typealias Body = EmptyBody
}

class BodyRequest<Model: Decodable, Body: Encodable>: IRequest {
    init(
        httpMethod: HTTPMethod,
        baseUrlString: String,
        path: String,
        queryParameters: [String: String],
        headers: [String: String]? = nil,
        body: Body? = nil
    ) {
        self.httpMethod = httpMethod
        self.baseUrlString = baseUrlString
        self.path = path
        self.queryParameters = queryParameters
        self.headers = headers
        self.body = body
    }
    
    var httpMethod: HTTPMethod
    
    var baseUrlString: String
    
    var path: String
    
    var queryParameters: [String: String]
    
    var headers: [String: String]?
    
    var body: Body?
    
    typealias Model = Model
    
    typealias Body = Body
}
