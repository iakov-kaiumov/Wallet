//
//  WalletsViewModel.swift
//  Wallet

import Foundation
import UIKit

protocol WalletsViewModelDelegate: AnyObject {
    func walletsViewModel(_ viewModel: WalletsViewModel, didSelectWallet wallet: WalletModel)
    func walletsViewModelDidAskToCreateWallet()
    func walletsViewModelSignOut()
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
        for i in 1...10 {
            wallets.append(WalletModel.getTestModel(i))
        }
    }

}
