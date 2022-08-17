//
//  NetworkService.swift
//  Wallet
//

import Foundation

class NetworkService {
    private let requestConstructor: IRequestConstructor = RequestConstructor()
    let requestProcessor: IRequestProcessor
    
    init() {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "accept": "application/json",
            "Content-Type": "application/json"
        ]
        let session = URLSession(configuration: configuration)
        
        requestProcessor = RequestProcessor(session: session, requestConstructor: requestConstructor)
    }
}
