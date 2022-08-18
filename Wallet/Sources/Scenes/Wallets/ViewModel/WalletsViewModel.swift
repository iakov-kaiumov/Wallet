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
    var onDidDeleteWallet: ((IndexPath) -> Void)?
    var onDidUpdateWallets: (() -> Void)?
    var onDidUpdateCurrencies: (() -> Void)?
    var onDidUpdateUserData: (() -> Void)?
    
    private var dependenices: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        
        self.dependenices = dependencies
        self.userData = PersonModel.skeletonModel
        self.currencyData = (0..<3).map { _ in CurrencyModel.makeSkeletonModel() }
        self.wallets = (0..<3).map { _ in WalletModel.makeSkeletonModel() }
        self.shownWallets = wallets
        
        dependencies.walletService.addDelegate(self)
    }
    
    // MARK: - Public Methods
    func load() {
        loadCurrencies()
        loadWallets()
        loadCurrencies()
        loadUserData()
    }
    
    func getWallet(at indexPath: IndexPath) -> WalletModel {
        if indexPath.section == 0 {
            return shownWallets[indexPath.row]
        } else {
            return hiddenWallets[indexPath.row]
        }
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
        } else {
            delegate?.walletsViewModel(self, didSelectWallet: getWallet(at: indexPath))
        }
    }
    
    func onCellDelete(_ indexPath: IndexPath) {
        let model = getWallet(at: indexPath)
        dependenices.walletService.walletServiceDelete(model.id) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.removeWallet(withId: model.id)
                }
            case .failure(let error):
                self.delegate?.walletsViewModel(self, didReceiveError: error)
            }
        }
    }
    
    func onCellHide(_ indexPath: IndexPath) {
        let wallet = getWallet(at: indexPath)
        
        for i in 0..<wallets.count where wallets[i].id == wallet.id {
            wallets[i].isHidden.toggle()
            editWallet(wallets[i])
        }
        updateShownWallets()
        
        if !isHidden {
            updateHiddenWallets()
        }
    }
    
    func onCellEdit(_ indexPath: IndexPath) {
        let wallet = getWallet(at: indexPath)
        delegate?.walletsViewModelEditWallet(wallet: wallet)
    }
    
    func signOut() {
        delegate?.walletsViewModelSignOut()
    }
    
    func haveHiddenWallets() -> Bool {
        wallets.filter { $0.isHidden }.count > 0
    }
    
    // MARK: - Private Methods
    private func removeWallet(withId id: Int) {
        if let row = shownWallets.firstIndex(where: { $0.id == id}) {
            shownWallets.remove(at: row)
            onDidDeleteWallet?(IndexPath(row: row, section: 0))
        }
        if let row = hiddenWallets.firstIndex(where: { $0.id == id}) {
            hiddenWallets.remove(at: row)
            onDidDeleteWallet?(IndexPath(row: row, section: 2))
        }
    }
    
    private func loadWallets() {
        dependenices.walletService.walletServiceGetAll { result in
            switch result {
            case .success:
                break
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
                    self.onDidUpdateCurrencies?()
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
                    self.onDidUpdateUserData?()
                }
            case .failure(let error):
                self.delegate?.walletsViewModel(self, didReceiveError: error)
            }
        }
    }
    
    private func editWallet(_ model: WalletModel) {
        dependenices.walletService.walletServiceEdit(model.makeApiModel()) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateHiddenWallets() {
        hiddenWallets = wallets.filter { $0.isHidden }
    }
    
    private func updateShownWallets() {
        shownWallets = wallets.filter { !$0.isHidden }
    }
}
    
extension WalletsViewModel: WalletServiceDelegate {
    func walletService(_ service: WalletServiceProtocol, didLoadWallets wallets: [WalletApiModel]) {
        let models = wallets.compactMap { WalletModel.fromApiModel($0) }
        DispatchQueue.main.async {
            self.wallets = models
            self.updateShownWallets()
            self.updateHiddenWallets()
            self.onDidUpdateWallets?()
        }
    }
}
