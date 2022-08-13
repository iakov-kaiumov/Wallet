//
//  IRequest.swift
//  Wallet
//

import Foundation

protocol IRequest {
    associatedtype Model: Decodable
    var httpMethod: HTTPMethod { get }
    var baseUrlString: String { get }
    var path: String { get }
    var queryParameters: [String: String] { get }
    var headers: [String: String]? { get }
    var body: String? { get }
}
