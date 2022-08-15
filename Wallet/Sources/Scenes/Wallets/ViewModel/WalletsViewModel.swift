//
//  WalletsViewModel.swift
//  Wallet

protocol WalletsViewModelDelegate: AnyObject {
    func walletsViewModel(_ viewModel: WalletsViewModel, didSelectWallet wallet: WalletModel)
}

final class WalletsViewModel {
    // MARK: - Properties
    weak var delegate: WalletsViewModelDelegate?
    
    var wallets: [WalletModel] = []
    var userData: PersonModel
    var currencyData: CurrenciesModel
    
    // MARK: - Init
    init() {
        userData = PersonModel.getTestModel()
        currencyData = CurrenciesModel.getTestModel()
        loadWallets()
    }
    
    // MARK: - Public Methods
    func selectWalletWithIndex(_ index: Int) {
        guard wallets.count > index else { return }
        delegate?.walletsViewModel(self, didSelectWallet: wallets[index])
    }
    
    // MARK: - Private Methods
    func loadWallets() {
        for i in 1...10 {
            wallets.append(WalletModel.getTestModel(i))
        }
    }
}
