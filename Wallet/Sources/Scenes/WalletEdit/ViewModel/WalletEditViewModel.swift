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
    
    func walletEditViewModelDidFinish(walletID: Int)
}

final class WalletEditViewModel {
    typealias Dependencies = HasWalletService
    // MARK: - Properties
    var isCreatingMode: Bool = true
    
    weak var delegate: WalletEditViewModelDelegate?
    
    var onDataChanged: (() -> Void)?
    
    var walletModel: WalletModel
    
    var tableItems: [WalletEditTableItem] = [
        WalletEditTableItem(type: .name, title: R.string.localizable.wallet_edit_name(), value: "Новый кошелек 1"),
        WalletEditTableItem(type: .currency, title: R.string.localizable.wallet_edit_currency(), value: "USD"),
        WalletEditTableItem(type: .limit, title: R.string.localizable.wallet_edit_limit(), value: "")
    ]
    
    private var dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies,
         wallet: WalletModel = .makeCleanModel()) {
        self.dependencies = dependencies
        self.walletModel = wallet
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
            delegate?.walletEditViewModelEnterCurrency(item.value)
        case .limit:
            delegate?.walletEditViewModelEnterLimit(item.value)
        }
    }
    
    func mainButtonDidTap() {
        if isCreatingMode {
            dependencies.walletService.walletServiceCreate(walletModel.makeApiModel()) { result in
                switch result {
                case .success(let model):
                    print("Nice. \(model)")
                    self.delegate?.walletEditViewModelDidFinish(walletID: model.id)
                case .failure(let error):
                    print("\(error)")
                }
            }
             
        }
 
    }
    
    func changeName(_ value: String?) {
        guard let index = itemIndex(for: .name) else { return }
        tableItems[index].value = value ?? ""
        onDataChanged?()
    }
    
    func changeCurrency(_ value: CurrencyType?) {
        guard let index = itemIndex(for: .currency) else { return }
        tableItems[index].value = value?.rawValue ?? ""
        onDataChanged?()
    }
    
    func changeLimit(_ value: String?) {
        guard let index = itemIndex(for: .limit) else { return }
        tableItems[index].value = value ?? ""
        onDataChanged?()
    }
}
