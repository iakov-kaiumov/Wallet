//
//  ProxyService+WalletService.swift
//  Wallet
//

import Foundation

extension ProxyService: WalletServiceProtocol {
    func addDelegate(_ delegate: WalletServiceDelegate) {
        networkService.addDelegate(delegate)
    }
    
    func walletServiceCreate(_ wallet: WalletApiModelShort, completion: @escaping (Result<WalletApiModelShort, NetworkError>) -> Void) {
        networkService.walletServiceCreate(wallet) { result in
            completion(result)
            self.walletServiceGetAll(completion: self.notifyWalletDelegates)
        }
    }
    
    func walletServiceGetAll(completion: @escaping (Result<[WalletApiModel], NetworkError>) -> Void) {
        networkService.walletServiceGetAll { result in
            completion(result)
            self.notifyWalletDelegates(result: result)
        }
    }
    
    func walletServiceEdit(_ wallet: WalletApiModelShort, completion: @escaping (Result<WalletApiModelShort, NetworkError>) -> Void) {
        networkService.walletServiceEdit(wallet) { result in
            completion(result)
            self.walletServiceGetAll(completion: self.notifyWalletDelegates)
        }
    }
    
    func walletServiceDelete(_ walletId: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        networkService.walletServiceDelete(walletId, completion: completion)
    }

    private func notifyWalletDelegates(result: Result<[WalletApiModel], NetworkError>) {
        switch result {
        case .success(let wallets):
            self.networkService.walletDelegates.forEach {
                $0.walletService(self, didLoadWallets: wallets)
            }
        case .failure:
            break
        }
    }
}
