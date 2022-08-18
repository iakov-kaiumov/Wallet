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
    
    func signIn(presenting controller: UIViewController, completion: @escaping (Result<String, NetworkError>) -> Void) {
        signInService.signIn(presenting: controller) { result in
            switch result {
            case .success(let idToken):
                self.signInServer(with: idToken) { result in
                    completion(result)
                }
            case .failure(let error):
                print(error)
                completion(result)
            }
        }
    }
    
    private func signInServer(with idToken: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        let person = PersonApiModel(email: idToken)
        let request = PersonRequestsFactory.makeCreateReqeust(person: person)
        requestProcessor.fetch(request) { result in
            switch result {
            case .success(let model):
                if let email = model.email {
                    completion(.success(email))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
      
}
