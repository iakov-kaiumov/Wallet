//
//  WalletService.swift
//  Wallet
//

import Foundation

protocol WalletServiceProtocol: AnyObject {
    func walletServiceCreate(_ wallet: WalletApiModel, completion: @escaping (Result<WalletModel, NetworkError>) -> Void)
    
    func walletServiceGetAll(completion: @escaping (Result<[WalletModel], NetworkError>) -> Void)
    
    func walletServiceEdit(_ wallet: WalletApiModel, completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void)
    
    func walletServiceDelete(_ walletId: Int, completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void)
}

extension NetworkService: WalletServiceProtocol {
    private var personID: Int { 1 }
    
    private func convertWallet(_ wallet: WalletApiModel) -> WalletModel? {
        guard let id = wallet.id,
              let personId = wallet.personId,
              let currency = wallet.currency,
              let currencyType = CurrencyType(rawValue: currency),
              let balance = wallet.balance,
              let income = wallet.income,
              let spendings = wallet.spendings else {
            return nil
        }
        
        return WalletModel(id: Int(id),
                           personId: Int(personId),
                           name: wallet.name,
                           currency: currencyType,
                           limit: wallet.amountLimit,
                           balance: balance,
                           income: income,
                           spendings: spendings)
    }
    
    func walletServiceCreate(_ wallet: WalletApiModel,
                             completion: @escaping (Result<WalletModel, NetworkError>) -> Void) {
        let request = WalletRequestsFactory.makeCreateReqeust(personId: personID,
                                                              wallet: wallet)
        requestProcessor.fetch(request) { result in
            switch result {
            case .success(let model):
                guard let result = self.convertWallet(model) else {
                    completion(.failure(.noData))
                    return
                }
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    func walletServiceGetAll(completion: @escaping (Result<[WalletModel], NetworkError>) -> Void) {
        let request = WalletRequestsFactory.makeGetAllReqeust(personId: personID)
        requestProcessor.fetch(request,
                               completion: completion)
    }
    
    func walletServiceEdit(_ wallet: WalletApiModel, completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void) {
        guard let walletID = wallet.id else { return }
        let request = WalletRequestsFactory.makeUpdateReqeust(walletId: Int(walletID),
                                                              personId: personID,
                                                              wallet: wallet)
        requestProcessor.fetch(request,
                               completion: completion)
    }
    
    func walletServiceDelete(_ walletId: Int, completion: @escaping (Result<WalletApiModel, NetworkError>) -> Void) {
        let request = WalletRequestsFactory.makeDeleteRequest(walletId: walletId,
                                                              personId: personID)
        requestProcessor.fetch(request, completion: completion)
        
    }
    
}
