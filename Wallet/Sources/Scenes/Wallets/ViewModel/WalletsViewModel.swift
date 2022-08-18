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
    func walletsViewModelEditWallet(wallet: WalletModel)
}

final class WalletsViewModel {
    typealias Dependencies = HasWalletService & HasCurrenciesService & HasPersonService
    // MARK: - Properties
    weak var delegate: WalletsViewModelDelegate?
    var wallets: [WalletModel] = []
    var shownWallets: [WalletModel] = []
    var hiddenWallets: [WalletModel] = []
    var userData: PersonModel
    var currencyData: [CurrencyModel]
    var isHidden: Bool = false
    var onHide: (() -> Void)?
    var onShow: (() -> Void)?
    
    var reloadData: (() -> Void)?
    var reloadCurrencyData: (() -> Void)?
    var reloadUserData: (() -> Void)?
    
    private var dependenices: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        self.dependenices = dependencies
        userData = PersonModel.skeletonModel
        currencyData = (0..<3).map { _ in CurrencyModel.makeSkeletonModel() }
        wallets = (0..<3).map { _ in WalletModel.makeSkeletonModel() }
        shownWallets = wallets
    }
    
    // MARK: - Public Methods
    func load() {
        loadWallets()
        loadCurrencies()
        loadUserData()
    }
    
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
        dependenices.walletService.walletServiceGetAll { result in
            switch result {
            case .success(let walletModels):
                self.wallets = walletModels.compactMap { WalletModel.fromApiModel($0) }
                DispatchQueue.main.async {
                    self.updateShownWallets()
                    self.updateHiddenWallets()
                    self.reloadData?()
                }
            case .failure(let error):
                self.delegate?.walletsViewModel(self, didReceiveError: error)
            }
        }
    }
    
    private func loadCurrencies() {
        dependenices.currenciesNetworkService.currenciesServiceGetDaily { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.currencyData = data.map { CurrencyModel.fromApiModel($0) }
                    self.reloadCurrencyData?()
                }
            case .failure(let error):
                self.delegate?.walletsViewModel(self, didReceiveError: error)
            }
        }
    }
    
    private func loadUserData() {
        dependenices.personNetworkService.personServiceGet { result in
            switch result {
            case .success(let person):
                let userData = PersonModel.fromApiModel(person)
                DispatchQueue.main.async {
                    self.userData = userData
                    self.reloadUserData?()
                }
            case .failure(let error):
                self.delegate?.walletsViewModel(self, didReceiveError: error)
            }
        }
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
