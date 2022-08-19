//
//  CacheService+WalletService.swift
//  Wallet
//

import Foundation

protocol WalletCacheServiceProtocol: AnyObject {
    func getAllWallets() -> [WalletModel]
    func setAllWallets(_ wallets: [WalletModel]) throws
}

extension CacheService: WalletCacheServiceProtocol {
    func getAllWallets() -> [WalletModel] {
        let wallets = getAllObjectsOfType(WalletModel.PersistentEntity.self)
        return wallets.compactMap { $0.makeTransient() }
    }
    
    func setAllWallets(_ wallets: [WalletModel]) throws {
        wallets.forEach { wallet in
            _ = wallet.makePersistent(context: writeContext)
        }
    }
    
}
