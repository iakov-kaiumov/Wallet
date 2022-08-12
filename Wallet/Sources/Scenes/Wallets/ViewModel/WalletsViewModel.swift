//
//  WalletsViewModel.swift
//  Wallet

class WalletsViewModel {
    
    // MARK: - Properties
    var wallets: [WalletModel] = []
    
    // MARK: - Init
    init() {
        loadWallets()
    }
    
    // MARK: - private methods
    func loadWallets() {
        for i in 1...10 {
            wallets.append(WalletModel.getTestModel(i))
        }
    }
}
