//
//  NetworkService.swift
//  Wallet
//

import Foundation

class NetworkService {
    let signInService: SignInService
    let requestProcessor: IRequestProcessor
    private let requestConstructor: IRequestConstructor = RequestConstructor()
    
    init(signInService: SignInService) {
        self.signInService = signInService
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "accept": "application/json",
            "Content-Type": "application/json"
        ]
        let session = URLSession(configuration: configuration)
        
        requestProcessor = RequestProcessor(session: session, requestConstructor: requestConstructor)
    }
}
