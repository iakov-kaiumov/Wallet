//
//  WalletsViewModel.swift
//  Wallet

protocol WalletsViewModelDelegate: AnyObject {
    func walletsViewModelCreateWallet()
}

final class WalletsViewModel {
    
    // MARK: - Properties
    var wallets: [WalletModel] = []
    var userData: PersonModel
    var currencyData: CurrenciesModel
    
    weak var delegate: WalletsViewModelDelegate?
    
    // MARK: - Init
    init() {
        userData = PersonModel.getTestModel()
        currencyData = CurrenciesModel.getTestModel()
        loadWallets()
    }
    
    // MARK: - private methods
    func loadWallets() {
        for i in 1...10 {
            wallets.append(WalletModel.getTestModel(i))
        }
    }
    
    func createWalletButtonDidTap() {
        delegate?.walletsViewModelCreateWallet()
    }
}
