//
//  WalletModel.swift
//  Wallet
//

import Foundation

struct WalletModel {
    var id: Int
    var name: String
    var currency: CurrencyModel
    var limit: Decimal?
    var balance: Decimal
    var income: Decimal
    var spendings: Decimal
    var isHidden: Bool
    var formattedBalance: String {
        balance.displayString(currency: currency)
    }
    
    var isLimitExceeded: Bool {
        guard let limit = limit else {
            return false
        }

        return spendings > limit
    }
    
    func makeApiModel() -> WalletApiModel {
        WalletApiModel(id: id,
                       name: name,
                       currency: currency.code,
                       amountLimit: limit,
                       balance: balance,
                       income: income,
                       spendings: spendings,
                       isHidden: isHidden)
    }
    
    static func makeCleanModel(_ id: Int = 0) -> WalletModel {
        return WalletModel(
            id: id,
            name: "Новый кошелек",
            currency: CurrencyModel.RUB,
            limit: nil,
            balance: 0,
            income: 0,
            spendings: 0,
            isHidden: Bool.random()
        )
        
    }
    
    static func makeTestModel(_ id: Int = 0) -> WalletModel {
        return WalletModel(
            id: id,
            name: "Тестовый кошелек №\(id)",
            currency: CurrencyModel.RUB,
            limit: Decimal(Double.random(in: 100000...1000000)),
            balance: Decimal(Double.random(in: 10000...100000)),
            income: Decimal(Double.random(in: 10000...100000)),
            spendings: Decimal(Double.random(in: 10000...100000)),
            isHidden: Bool.random()
        )
    }
}

extension WalletModel {
    static func fromApiModel(_ wallet: WalletApiModel) -> WalletModel? {
        guard
//              let currency = wallet.currency,
              let balance = wallet.balance,
              let income = wallet.income,
              let spendings = wallet.spendings,
              let isHidden = wallet.isHidden else {
            return nil
        }
        
        return WalletModel(
            id: wallet.id,
            name: wallet.name,
            currency: CurrencyModel.RUB,
            limit: wallet.amountLimit,
            balance: balance,
            income: income,
            spendings: spendings,
            isHidden: isHidden
        )
    }
}
