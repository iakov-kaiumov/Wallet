//
//  GoogleAuth.swift
//  Wallet
//
//  Created by Яков Каюмов on 15.08.2022.
//

import Foundation
import GoogleSignIn

class SignInService {
    private init() {
        
    }
    
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
        /*
        guard let authData = try? JSONEncoder().encode(["idToken": idToken]) else {
            return
        }
        let url = URL(string: "https://yourbackend.example.com/tokensignin")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
            // Handle response from your backend.
        }
        task.resume()
         */
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

extension SignInService {
    static let shared: SignInService = SignInService()
}
