//
//  ExampleRequest.swift
//  Wallet
//

import Foundation

struct ExampleRequest: IRequest {
    
    typealias Model = ExampleResult
    
    let httpMethod: HTTPMethod = .GET
    let baseUrlString: String = DefaultNetworkSettings.baseUrl
    let path: String = "/2.3/questions"
    let page: UInt
    let count: UInt
    
    var queryParameters: [String: String] {
        [
            "site": "stackoverflow",
            "page": "\(page)",
            "count": "\(count)"
        ]
    }
    
    var headers: [String: String]?
    
    var body: String?
}
