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
        guard let id = wallet.id,
              let currency = wallet.currency,
              let currencyType = CurrencyType(rawValue: currency),
              let isHidden = wallet.isHidden else {
            return nil
        }
        
        return WalletModel(id: Int(id),
                           name: wallet.name,
                           currency: currencyType,
                           limit: wallet.amountLimit,
                           balance: 0,
                           income: 0,
                           spendings: 0,
                           isHidden: isHidden)
    }
    
    func walletServiceCreate(_ wallet: WalletApiModel,
                             completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void) {
        let request = WalletRequestsFactory.makeCreateReqeust(wallet: wallet)
        requestProcessor.fetch(request, completion: completion)
    }
    
    func walletServiceGetAll(completion: @escaping (Result<[WalletApiModel], NetworkError>) -> Void) {
        let request = WalletRequestsFactory.makeGetAllReqeust()
        requestProcessor.fetch(request, completion: completion)
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
