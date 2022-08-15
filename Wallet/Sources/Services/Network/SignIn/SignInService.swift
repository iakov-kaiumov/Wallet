//
//  GoogleAuth.swift
//  Wallet
//
//  Created by Яков Каюмов on 15.08.2022.
//

import Foundation
import GoogleSignIn

class SignInService {
    
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
    
    private func signInServer(with idToken: String, completion: @escaping (_ success: Bool) -> Void) {
        completion(true)
        return
        
        // TODO: Add server authentication
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
    
    func signIn(presenting controller: UIViewController, completion: @escaping (_ success: Bool) -> Void) {
        guard let signInConfig = getSignInConfig() else {
            completion(false)
            return
        }
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: controller) { [weak self] user, error in
            guard error == nil else {
                completion(false)
                return
            }
            guard let user = user else {
                completion(false)
                return
            }

            user.authentication.do { authentication, error in
                guard error == nil else {
                    completion(false)
                    return
                }
                guard let authentication = authentication, let idToken = authentication.idToken else {
                    completion(false)
                    return
                }
                
                self?.signInServer(with: idToken, completion: completion)
            }
        }
    }
}
