//
//  WalletEditViewModel.swift
//  Wallet
//

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
    
    func walletEditViewModelEnterCurrency(_ currentValue: String?)
    
    func walletEditViewModelEnterLimit(_ currentValue: String?)
    
    func walletEditViewModelDidFinish()
}

final class WalletEditViewModel {
    // MARK: - Properties
    var isCreatingMode: Bool = true
    
    weak var delegate: WalletEditViewModelDelegate?
    
    var onDataChanged: (() -> Void)?
    
    var tableItems: [WalletEditTableItem] = [
        WalletEditTableItem(type: .name, title: R.string.localizable.wallet_edit_name(), value: "Новый кошелек 1"),
        WalletEditTableItem(type: .currency, title: R.string.localizable.wallet_edit_currency(), value: "USD"),
        WalletEditTableItem(type: .limit, title: R.string.localizable.wallet_edit_limit(), value: "")
    ]
    
    // MARK: - Public
    func itemIndex(for type: WalletEditFieldType) -> Int? {
        return tableItems.firstIndex(where: { $0.type == type })
    }
    
    func cellDidTap(item: WalletEditTableItem) {
        switch item.type {
        case .name:
            delegate?.walletEditViewModelEnterName(item.value)
        case .currency:
            delegate?.walletEditViewModelEnterCurrency(item.value)
        case .limit:
            delegate?.walletEditViewModelEnterLimit(item.value)
        }
    }
    
    func nextButtonDidTap() {
        delegate?.walletEditViewModelDidFinish()
    }
    
    func changeName(_ value: String?) {
        guard let index = itemIndex(for: .name) else { return }
        tableItems[index].value = value ?? ""
        onDataChanged?()
    }
    
    func changeCurrency(_ value: CurrencyType?) {
        guard let index = itemIndex(for: .name) else { return }
        tableItems[index].value = value?.rawValue ?? ""
        onDataChanged?()
    }
    
    func changeLimit(_ value: String?) {
        guard let index = itemIndex(for: .name) else { return }
        tableItems[index].value = value ?? ""
        onDataChanged?()
    }
}
