//
//  NetworkService.swift
//  Wallet
//

import Foundation

class NetworkService {
    let signInService: SignInService
    var requestProcessor: IRequestProcessor
    private let requestConstructor: IRequestConstructor = RequestConstructor()
    var walletDelegates: DelegatesList<WalletServiceDelegate> = DelegatesList<WalletServiceDelegate>()
    
    init(signInService: SignInService) {
        self.signInService = signInService
        requestProcessor = NetworkService.makeDefaultRequestProcessor()
    }
    
    func setup() {
        requestProcessor = NetworkService.makeDefaultRequestProcessor()
    }
    
    private static func makeDefaultRequestProcessor() -> IRequestProcessor {
        let constructor = RequestConstructor()
        let session = NetworkService.makeDefaultURLSession()
        return RequestProcessor(session: session, requestConstructor: constructor)
    }
    
    private static func makeDefaultURLSession() -> URLSession {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "accept": "application/json",
            "Content-Type": "application/json"
        ]
        if let token = UserDefaults.standard.string(forKey: "token") {
            configuration.httpAdditionalHeaders?["email"] = token
        }
        let session = URLSession(configuration: configuration)
        return session
    }
}
