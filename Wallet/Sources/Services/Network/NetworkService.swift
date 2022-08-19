//
//  NetworkService.swift
//  Wallet
//

import Foundation

class NetworkService {
    let internetChecker = try? Reachability()
    
    let signInService: SignInService
    var requestProcessor: IRequestProcessor
    
    var walletDelegates: DelegatesList<WalletServiceDelegate> = DelegatesList<WalletServiceDelegate>()
    
    var operationDelegates: DelegatesList<OperationServiceDelegate> = DelegatesList<OperationServiceDelegate>()
    
    var personDelegates: DelegatesList<PersonServiceDelegate> = DelegatesList<PersonServiceDelegate>()
    
    init(signInService: SignInService) {
        self.signInService = signInService
        requestProcessor = NetworkService.makeDefaultRequestProcessor()
    }
    
    func setup() {
        requestProcessor = NetworkService.makeDefaultRequestProcessor()
    }
    
    private static func makeDefaultRequestProcessor() -> IRequestProcessor {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let constructor = RequestConstructor(encoder: encoder)
        let session = NetworkService.makeDefaultURLSession()
        
        return RequestProcessor(session: session,
                                requestConstructor: constructor,
                                decoder: decoder)
    }
    
    private static func makeDefaultURLSession() -> URLSession {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
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
