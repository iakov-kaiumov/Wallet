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
    
    func signIn(presenting controller: UIViewController,
                completion: @escaping (Bool) -> Void) {
        signInService.signIn(presenting: controller, completion: completion)
    }
    
    func signInServer(with idToken: String, completion: @escaping (Bool) -> Void) {
        signInService.signInServer(with: idToken) { result in
            // TODO: - Make request to company server
            completion(result)
        }
    }
      
}
