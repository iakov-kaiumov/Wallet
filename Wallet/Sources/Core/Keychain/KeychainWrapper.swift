//
//  KeychainWrapper.swift
//  Wallet
//

import Foundation

final class KeychainWrapper {
    
    private var account: String
    
    static let standard = KeychainWrapper(account: "standard")
    
    private init(account: String) {
        self.account = account
    }
    
    func set(_ data: Data, forKey key: String) {
        // Create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: key,
            kSecAttrAccount: account
        ] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            // Print out the error
            print("Error: \(status)")
        }
        
        if status == errSecDuplicateItem {
            // Item already exist, thus update it.
            let query = [
                kSecAttrService: key,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary

            // Update existing item
            SecItemUpdate(query, attributesToUpdate)
        }
    }
    
    func data(forKey key: String) -> Data? {
        let query = [
            kSecAttrService: key,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return result as? Data
    }
    
    func removeObject(forKey key: String) {
        let query = [
            kSecAttrService: key,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        // Delete item from keychain
        SecItemDelete(query)
    }
}

extension KeychainWrapper {
    func set(_ value: String, forKey key: String) {
        if let data = value.data(using: .utf8) {
            self.set(data, forKey: key)
        }
    }
    
    func string(forKey key: String) -> String? {
        if let data = data(forKey: key) {
            return String(decoding: data, as: UTF8.self)
        }
        return nil
    }
}
