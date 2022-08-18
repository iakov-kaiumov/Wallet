//
//  ProxyService+WalletService.swift
//  Wallet
//

import Foundation

extension ProxyService: WalletServiceProtocol {
    func walletServiceCreate(_ wallet: WalletApiModel, completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void) {
        networkService.walletServiceCreate(wallet, completion: completion)
    }
    
    func walletServiceGetAll(completion: @escaping (Result<[WalletApiModel], NetworkError>) -> Void) {
        networkService.walletServiceGetAll(completion: completion)
        // TODO: - Get rid of it
        if let person = cacheService.getPerson() {
            print(person)
            print("shooshoonchick")
        } else {
            let person = PersonModel(id: 5,
                                     email: "aboba",
                                     personBalance: 100,
                                     personIncome: 200,
                                     personSpendings: 300)
            cacheService.savePerson(person: person)
        }
    }
    
    func walletServiceEdit(_ wallet: WalletApiModel, completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void) {
        networkService.walletServiceEdit(wallet, completion: completion)
    }
    
    func walletServiceDelete(_ walletId: Int, completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void) {
        networkService.walletServiceDelete(walletId, completion: completion)
    }

}
