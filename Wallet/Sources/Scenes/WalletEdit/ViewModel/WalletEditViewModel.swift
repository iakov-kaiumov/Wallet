//
//  WalletEditViewModel.swift
//  Wallet
//

enum WalletEditFieldType: Int {
    case name, currency, limit
}

struct EditTableItem {
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
    var isCreatingMode: Bool = true
    
    weak var delegate: WalletEditViewModelDelegate?
    
    var onDataChanged: (() -> Void)?
    
    var tableItems: [EditTableItem] = [
        EditTableItem(type: .name, title: R.string.localizable.wallet_edit_name(), value: "Новый кошелек 1"),
        EditTableItem(type: .currency, title: R.string.localizable.wallet_edit_currency(), value: "USD"),
        EditTableItem(type: .limit, title: R.string.localizable.wallet_edit_limit(), value: "")
    ]
    
    func cellDidTap(item: EditTableItem) {
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
        tableItems[0].value = value ?? ""
        onDataChanged?()
    }
    
    func changeCurrency(_ value: CurrencyType?) {
        tableItems[1].value = value?.rawValue ?? ""
        onDataChanged?()
    }
    
    func changeLimit(_ value: String?) {
        tableItems[2].value = value ?? ""
        onDataChanged?()
    }
}
