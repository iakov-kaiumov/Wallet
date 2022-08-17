//
//  ProxyService+SignInService.swift
//  Wallet
//

import UIKit

extension ProxyService: GoogleSignInServiceProtocol {
    func handle(_ url: URL) -> Bool {
        networkService.handle(url)
    }
    
    func checkSignInStatus(_ completion: @escaping (Bool) -> Void) {
        networkService.checkSignInStatus(completion)
    }
    
    func signOut() {
        networkService.signOut()
    }
    
    func signIn(presenting controller: UIViewController,
                completion: @escaping (Bool) -> Void) {
        networkService.signIn(presenting: controller,
                              completion: completion)
    }
    
    func signInServer(with idToken: String, completion: @escaping (Bool) -> Void) {
        networkService.signInServer(with: idToken) { result in
            // TODO: - Cache token
            completion(result)
        }
    }
    
}
