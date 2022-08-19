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
        
        guard networkService.internetChecker?.connection != .unavailable else {
            let wallets = getWalletsFromCache()
            completion(.success(wallets))
            self.notifyWalletDelegates(result: .success(wallets))
            return
        }
        
        // get from network
        networkService.walletServiceGetAll { result in
            switch result {
            case .success(let models):
                print(models)
            case .failure(let error):
                print(error)
                let wallets = self.getWalletsFromCache()
                completion(.success(wallets))
                self.notifyWalletDelegates(result: .success(wallets))
                return
            }
            completion(result)
            self.notifyWalletDelegates(result: result)
        }
    }
    
    private func getWalletsFromCache() -> [WalletApiModel] {
        let wallets = cacheService.getAllWallets()
        let converted = wallets.map { $0.makeFullApiModel() }
        return converted
    }
    
    func walletServiceEdit(_ wallet: WalletApiModelShort, completion: @escaping (Result<WalletApiModelShort, NetworkError>) -> Void) {
        guard networkService.internetChecker?.connection != .unavailable else {
            self.notifyWalletDelegates(result: .failure(.urlError))
            return
        }
        networkService.walletServiceEdit(wallet) { result in
            completion(result)
            self.walletServiceGetAll(completion: self.notifyWalletDelegates)
        }
    }
    
    func walletServiceDelete(_ walletId: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        networkService.walletServiceDelete(walletId) { result in
            completion(result)
            self.personServiceGet(completion: { _ in })
        }
    }
    
    private func notifyWalletDelegates(result: Result<[WalletApiModel], NetworkError>) {
        switch result {
        case .success(let wallets):
            let convertedModels = wallets.compactMap { WalletModel.fromApiModel($0) }
            try? self.cacheService.deleteAllObjectsOfType(CDWallet.self)
            try? self.cacheService.setAllWallets(convertedModels)
            try? self.cacheService.saveWriteContext()
            
            self.networkService.walletDelegates.forEach {
                $0.walletService(self, didLoadWallets: wallets)
            }
        case .failure:
            break
        }
    }
}
