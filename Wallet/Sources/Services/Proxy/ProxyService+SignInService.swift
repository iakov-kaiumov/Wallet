//
//  ProxyService+SignInService.swift
//  Wallet
//

import UIKit

extension ProxyService: SignInServiceProtocol {
    func handle(_ url: URL) -> Bool {
        networkService.handle(url)
    }
    
    func checkSignInStatus(_ completion: @escaping (Bool) -> Void) {
        networkService.checkSignInStatus(completion)
    }
    
    func signOut() {
        networkService.signOut()
    }
    
    func signIn(presenting controller: UIViewController, completion: @escaping (Result<String, NetworkError>) -> Void) {
        networkService.signIn(presenting: controller) { [weak self] result in
            self?.processServerResult(result)
            completion(result)
        }
    }
    
    func signInWithServer(idToken: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        networkService.signInWithServer(idToken: idToken) { [weak self] result in
            self?.processServerResult(result)
            completion(result)
        }
    }
    
    private func processServerResult(_ result: Result<String, NetworkError>) {
        switch result {
        case .success(let token):
            KeychainWrapper.standard.set(token, forKey: "token")
            DispatchQueue.main.async {
                self.networkService.setup()
            }
            
        case .failure(let error):
            print(error)
        }
    }
}
