//
//  GoogleAuth.swift
//  Wallet
//
//  Created by Яков Каюмов on 15.08.2022.
//

import Foundation
import GoogleSignIn

protocol GoogleSignInServiceProtocol {
    func handle(_ url: URL) -> Bool
    
    func checkSignInStatus(_ completion: @escaping (_ isSignedIn: Bool) -> Void)
    
    func signOut()
    
    func signIn(presenting controller: UIViewController, completion: @escaping (_ result: Result<String, NetworkError>) -> Void)
    
}

class SignInService: GoogleSignInServiceProtocol {
    // MARK: - Public methods
    func handle(_ url: URL) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func checkSignInStatus(_ completion: @escaping (_ isSignedIn: Bool) -> Void) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            let isSignedIn = error == nil && user != nil
            completion(isSignedIn)
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    func signIn(presenting controller: UIViewController, completion: @escaping (_ result: Result<String, NetworkError>) -> Void) {
        guard let signInConfig = getSignInConfig() else {
            completion(.failure(.noData))
            return
        }
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: controller) { user, error in
            guard error == nil else {
                completion(.failure(.noData))
                return
            }
            guard let user = user else {
                completion(.failure(.noData))
                return
            }

            guard let email = user.profile?.email else {
                completion(.failure(.noData))
                return
            }
            completion(.success(email))
        }
    }
    
    // MARK: - Private methods
    private func getSignInConfig() -> GIDConfiguration? {
        guard let path = Bundle.main.path(forResource: "credentials", ofType: "plist") else {
            return nil
        }

        guard let dictionary = NSDictionary(contentsOfFile: path) else {
            return nil
        }

        if let clientId = dictionary.object(forKey: "CLIENT_ID") as? String {
            return GIDConfiguration(clientID: clientId)
        }
        return nil
    }
}
