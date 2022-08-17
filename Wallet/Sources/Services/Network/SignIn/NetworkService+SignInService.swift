//
//  NetworkService+SignInService.swift
//  Wallet
//

import UIKit

extension NetworkService: GoogleSignInServiceProtocol {
    func handle(_ url: URL) -> Bool {
        signInService.handle(url)
    }
    
    func checkSignInStatus(_ completion: @escaping (Bool) -> Void) {
        signInService.checkSignInStatus(completion)
    }
    
    func signOut() {
        signInService.signOut()
    }
    
    func signIn(presenting controller: UIViewController, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        signInService.signIn(presenting: controller) { result in
            switch result {
            case .success(let idToken):
                self.signInServer(with: idToken) { result in
                    completion(true)
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    private func signInServer(with idToken: String, completion: @escaping (Bool) -> Void) {
        
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "accept": "application/json",
            "Content-Type": "application/json"
        ]
        let session = URLSession(configuration: configuration)
        
        let simpleProcessor = RequestProcessor(session: session, requestConstructor: RequestConstructor())
        
        let person = PersonApiModel(email: idToken)
        let request = PersonRequestsFactory.makeCreateReqeust(person: person)
        simpleProcessor.fetch(request) { result in
            switch result {
            case .success(let model):
                UserDefaults.standard.set(model.email, forKey: "token")
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
      
}
