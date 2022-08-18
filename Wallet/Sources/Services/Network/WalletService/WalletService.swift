//
//  WalletService.swift
//  Wallet
//

import Foundation

protocol WalletServiceProtocol: AnyObject {
    func walletServiceCreate(_ wallet: WalletApiModel, completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void)
    
    func walletServiceGetAll(completion: @escaping (Result<[WalletApiModel], NetworkError>) -> Void)
    
    func walletServiceEdit(_ wallet: WalletApiModel, completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void)
    
    func walletServiceDelete(_ walletId: Int, completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void)
}

extension NetworkService: WalletServiceProtocol {
    private func convertWallet(_ wallet: WalletApiModel) -> WalletModel? {
        return WalletModel(id: wallet.id,
                           name: wallet.name,
                           currency: .RUB,
                           limit: wallet.amountLimit,
                           balance: wallet.balance ?? 0,
                           income: wallet.income ?? 0,
                           spendings: wallet.spendings ?? 0,
                           isHidden: wallet.isHidden ?? false)
    }
    
    func walletServiceCreate(_ wallet: WalletApiModel,
                             completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void) {
        let request = WalletRequestsFactory.makeCreateReqeust(wallet: wallet)
        requestProcessor.fetch(request, completion: completion)
    }
    
    func walletServiceGetAll(completion: @escaping (Result<[WalletApiModel], NetworkError>) -> Void) {
        let request = WalletRequestsFactory.makeGetAllReqeust()
        requestProcessor.fetch(request) { result in
            switch result {
            case .success(let models):
                let result = models.compactMap({ model in
                    self.convertWallet(model)
                })
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func walletServiceEdit(_ wallet: WalletApiModel, completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void) {
        let request = WalletRequestsFactory.makeUpdateReqeust(walletId: wallet.id, wallet: wallet)
        requestProcessor.fetch(request, completion: completion)
    }
    
    func walletServiceDelete(_ walletId: Int, completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void) {
        let request = WalletRequestsFactory.makeDeleteRequest(walletId: walletId)
        requestProcessor.fetch(request, completion: completion)
        
    }
    
}
