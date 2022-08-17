//
//  WalletsViewModel.swift
//  Wallet

import Foundation
import UIKit

protocol WalletsViewModelDelegate: AnyObject {
    func walletsViewModel(_ viewModel: WalletsViewModel, didSelectWallet wallet: WalletModel)
    func walletsViewModel(_ viewModel: WalletsViewModel, didReceiveError error: Error)
    func walletsViewModelDidAskToCreateWallet()
    func walletsViewModelSignOut()
}

final class WalletsViewModel {
    typealias Dependencies = HasWalletServiceProtocol
    // MARK: - Properties
    weak var delegate: WalletsViewModelDelegate?
    
    var wallets: [WalletModel] = []
    var userData: PersonModel
    var currencyData: CurrenciesModel
    
    var reloadData: (() -> Void)?
    
    private var dependenices: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        self.dependenices = dependencies
        userData = PersonModel.makeTestModel()
        currencyData = CurrenciesModel.getTestModel()
        loadWallets()
    }
    
    // MARK: - Public Methods
    func selectWalletWithIndex(_ index: Int) {
        guard wallets.count > index else { return }
        delegate?.walletsViewModel(self, didSelectWallet: wallets[index])
    }
    
    func createWalletButtonDidTap() {
        delegate?.walletsViewModelDidAskToCreateWallet()
    }
    
    func onCellTapped(_ indexPath: IndexPath) {
        
    }
    
    func onCellDelete(_ indexPath: IndexPath) {
        
    }
    
    func onCellHide(_ indexPath: IndexPath) {
        
    }
    
    func onCellEdit(_ indexPath: IndexPath) {
        
    }
    
    func signOut() {
        delegate?.walletsViewModelSignOut()
    }
    
    // MARK: - Private Methods
    private func loadWallets() {
        dependenices.walletNetworkService.walletServiceGetAll { result in
            switch result {
            case .success(let walletModels):
                self.wallets = walletModels
                self.reloadData?()
            case .failure(let error):
                self.delegate?.walletsViewModel(self, didReceiveError: error)
            }
        }
    }
}
