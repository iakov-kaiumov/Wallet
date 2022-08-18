//
//  WalletEditViewModel.swift
//  Wallet
//

import Foundation

enum WalletEditFieldType: Int {
    case name, currency, limit
}

struct WalletEditTableItem {
    var type: WalletEditFieldType
    var title: String
    var value: String
}

protocol WalletEditViewModelDelegate: AnyObject {
    func walletEditViewModelEnterName(_ currentValue: String?)
    
    func walletEditViewModelEnterCurrency(_ currentValue: CurrencyModel)
    
    func walletEditViewModelEnterLimit(_ currentValue: String?)
    
    func walletEditViewModelDidFinish(walletID: Int)
    
    func walletsViewModel(_ viewModel: WalletEditViewModel, didReceiveError error: Error)
}

final class WalletEditViewModel {
    typealias Dependencies = HasWalletService
    // MARK: - Properties
    var isCreatingMode: Bool = true
    
    weak var delegate: WalletEditViewModelDelegate?
    
    var onDataChanged: (() -> Void)?
    var onDidStartLoading: (() -> Void)?
    var onDidStopLoading: (() -> Void)?
    
    var walletModel: WalletModel
    
    var tableItems: [WalletEditTableItem] = []
    
    private var dependencies: Dependencies
    
    private lazy var formatter: IWalletEditViewModelFormatter = WalletEditViewModelFormatter()
    
    // MARK: - Init
    init(dependencies: Dependencies, wallet: WalletModel = .makeCleanModel()) {
        self.dependencies = dependencies
        self.walletModel = wallet
        
        loadItems()
    }
        
    // MARK: - Public Methods
    func itemIndex(for type: WalletEditFieldType) -> Int? {
        return tableItems.firstIndex(where: { $0.type == type })
    }
    
    func cellDidTap(item: WalletEditTableItem) {
        switch item.type {
        case .name:
            delegate?.walletEditViewModelEnterName(item.value)
        case .currency:
            delegate?.walletEditViewModelEnterCurrency(walletModel.currency)
        case .limit:
            delegate?.walletEditViewModelEnterLimit(item.value)
        }
    }
    
    func mainButtonDidTap() {
        if isCreatingMode {
            onDidStartLoading?()
            dependencies.walletService.walletServiceCreate(walletModel.makeApiModel(), completion: onServerResponse)
        } else {
            onDidStartLoading?()
            dependencies.walletService.walletServiceEdit(walletModel.makeApiModel(), completion: onServerResponse)
        }
    }
    
    private func onServerResponse(result: Result<WalletApiModel, NetworkError>) {
        switch result {
        case .success(let model):
            DispatchQueue.main.async {
                self.delegate?.walletEditViewModelDidFinish(walletID: model.id)
            }
        case .failure(let error):
            self.onDidStopLoading?()
            self.delegate?.walletsViewModel(self, didReceiveError: error)
        }
    }
    
    func changeName(_ value: String?) {
        guard let index = itemIndex(for: .name) else { return }
        if let value = value {
            walletModel.name = value
            tableItems[index].value = formatter.formatName(walletModel)
            onDataChanged?()
        }
    }
    
    func changeCurrency(_ value: CurrencyModel?) {
        guard let index = itemIndex(for: .currency) else { return }
        if let value = value {
            walletModel.currency = value
            tableItems[index].value = formatter.formatCurrency(walletModel)
            onDataChanged?()
        }
    }
    
    func changeLimit(_ value: String?) {
        guard let index = itemIndex(for: .limit) else { return }
        if let value = value, let number = Double(value) {
            walletModel.limit = Decimal(number)
        } else {
            walletModel.limit = nil
        }
        tableItems[index].value = formatter.formatLimit(walletModel)
        onDataChanged?()
    }
    
    private func loadItems() {
        tableItems = [
            WalletEditTableItem(
                type: .name,
                title: R.string.localizable.wallet_edit_name(),
                value: formatter.formatName(walletModel)
            ),
            WalletEditTableItem(
                type: .currency,
                title: R.string.localizable.wallet_edit_currency(),
                value: formatter.formatCurrency(walletModel)
            ),
            WalletEditTableItem(
                type: .limit,
                title: R.string.localizable.wallet_edit_limit(),
                value: formatter.formatLimit(walletModel)
            )
        ]
    }
}
