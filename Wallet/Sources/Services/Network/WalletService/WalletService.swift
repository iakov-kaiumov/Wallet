//
//  WalletService.swift
//  Wallet
//

import Foundation

protocol WalletServiceDelegate: AnyObject {
    func walletService(_ service: WalletServiceProtocol, didLoadWallets wallets: [WalletApiModel])
}

protocol WalletServiceProtocol: AnyObject {
    func walletServiceCreate(_ wallet: WalletApiModel, completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void)
    
    func walletServiceGetAll(completion: @escaping (Result<[WalletApiModel], NetworkError>) -> Void)
    
    func walletServiceEdit(_ wallet: WalletApiModel, completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void)
    
    func walletServiceDelete(_ walletId: Int, completion: @escaping (Result<Data, NetworkError>) -> Void)
    
    func addDelegate(_ delegate: WalletServiceDelegate)
}

extension NetworkService: WalletServiceProtocol {
    func addDelegate(_ delegate: WalletServiceDelegate) {
        walletDelegates.addDelegate(delegate)
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
    
    func walletServiceDelete(_ walletId: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let request = WalletRequestsFactory.makeDeleteRequest(walletId: walletId)
        requestProcessor.fetchData(request, completion: completion)
    }
}
