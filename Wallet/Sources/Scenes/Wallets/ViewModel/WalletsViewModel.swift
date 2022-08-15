//
//  WalletsViewModel.swift
//  Wallet

import Foundation
import UIKit

protocol WalletsViewModelDelegate: AnyObject {
    func walletsViewModel(_ viewModel: WalletsViewModel, didSelectWallet wallet: WalletModel)
    func walletsViewModelDidAskToCreateWallet()
}

final class WalletsViewModel {
    
    // MARK: - Properties
    weak var delegate: WalletsViewModelDelegate?
    
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
    
    func onCellTapped(_ indexPath: IndexPath) {
        
    }
    
    func onCellDelete(_ indexPath: IndexPath) {
        
    }
    
    func onCellHide(_ indexPath: IndexPath) {
        
    }
    
    func onCellEdit(_ indexPath: IndexPath) {
        
    }
        
    func createWalletButtonDidTap() {
        delegate?.walletsViewModelCreateWallet()
    }
}
