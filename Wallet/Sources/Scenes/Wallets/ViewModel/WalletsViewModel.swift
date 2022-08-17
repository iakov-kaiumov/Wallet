//
//  WalletsViewModel.swift
//  Wallet

import Foundation
import UIKit

protocol WalletsViewModelDelegate: AnyObject {
    func walletsViewModel(_ viewModel: WalletsViewModel, didSelectWallet wallet: WalletModel)
    func walletsViewModelDidAskToCreateWallet()
    func walletsViewModelSignOut()
    func walletsViewModelEditWallet(wallet: WalletModel)
}

final class WalletsViewModel {
    
    // MARK: - Properties
    weak var delegate: WalletsViewModelDelegate?
    var wallets: [WalletModel] = []
    var shownWallets: [WalletModel] = []
    var hiddenWallets: [WalletModel] = []
    var userData: PersonModel
    var currencyData: CurrenciesModel
    var isHidden: Bool = false
    var onHide: (() -> Void)?
    var onShow: (() -> Void)?
    
    // MARK: - Init
    init() {
        userData = PersonModel.getTestModel()
        currencyData = CurrenciesModel.getTestModel()
        loadWallets()
    }
    
    // MARK: - Public Methods
    func selectWalletWithIndex(_ index: Int, section: Int) {
        var wallets: [WalletModel]
        if section == 0 {
            wallets = shownWallets
        } else if section == 2 {
            wallets = hiddenWallets
        } else {
            return
        }
        
        guard wallets.count > index else { return }
        
        delegate?.walletsViewModel(self, didSelectWallet: wallets[index])
    }
    
    func makeShowMoreCellModel() -> ShowMoreCell.Model {
        let text = isHidden ? R.string.localizable.wallets_hidden_wallets() : R.string.localizable.wallets_hide()
        
        return ShowMoreCell.Model(text: text, isShowMore: isHidden)
    }
    
    func createWalletButtonDidTap() {
        delegate?.walletsViewModelDidAskToCreateWallet()
    }
    
    func onCellTapped(_ indexPath: IndexPath) {
        if indexPath.section == 1 {
            isHidden.toggle()
            if isHidden {
                hiddenWallets = []
                onHide?()
            } else {
                updateHiddenWallets()
                onShow?()
            }
            return
        }
    }
    
    func onCellDelete(_ indexPath: IndexPath) {
        
    }
    
    func onCellHide(_ indexPath: IndexPath) {
        let wallet = findWalletByIndexPath(indexPath: indexPath)
        
        for i in 0..<wallets.count where wallets[i].id == wallet.id {
            wallets[i].isHidden.toggle()
        }
        updateShownWallets()
        
        if !isHidden {
            updateHiddenWallets()
        }
    }
    
    func onCellEdit(_ indexPath: IndexPath) {
        let wallet = findWalletByIndexPath(indexPath: indexPath)
        delegate?.walletsViewModelEditWallet(wallet: wallet)
    }
    
    func signOut() {
        delegate?.walletsViewModelSignOut()
    }
    
    func haveHiddenWallets() -> Bool {
        wallets.filter { $0.isHidden }.count > 0
    }
    
    // MARK: - Private Methods
    private func loadWallets() {
        for i in 1...5 {
            wallets.append(WalletModel.getTestModel(i))
        }
        
        updateShownWallets()
        updateHiddenWallets()
    }

    private func updateHiddenWallets() {
        hiddenWallets = wallets.filter { $0.isHidden }
    }
    
    private func updateShownWallets() {
        shownWallets = wallets.filter { !$0.isHidden }
    }
    
    private func findWalletByIndexPath(indexPath: IndexPath) -> WalletModel {
        if indexPath.section == 0 {
            return shownWallets[indexPath.row]
        } else {
            return hiddenWallets[indexPath.row]
        }
    }
}
