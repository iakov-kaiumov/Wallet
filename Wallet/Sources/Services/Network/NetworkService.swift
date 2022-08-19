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
    
    var operationDelegates: DelegatesList<OperationServiceDelegate> = DelegatesList<OperationServiceDelegate>()
    
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
        let decoder = JSONDecoder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return RequestProcessor(session: session,
                                requestConstructor: constructor,
                                decoder: decoder)
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
