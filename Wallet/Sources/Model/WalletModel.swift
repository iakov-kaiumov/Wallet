//
//  WalletModel.swift
//  Wallet
//

import Foundation
import CoreData

struct WalletModel: Transient {
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
    var isSkeleton: Bool = false
    
    var isLimitExceeded: Bool {
        guard let limit = limit else {
            return false
        }

        return spendings > limit
    }
    
    func makePersistent(context: NSManagedObjectContext) -> CDWallet? {
        let wallet = CDWallet(context: context)
        wallet.id = Int64(id)
        wallet.name = name
        wallet.currency = currency.makePersistent(context: context)
        if let limit = limit {
            wallet.amountLimit = NSDecimalNumber(decimal: limit)
        }
        wallet.balance = NSDecimalNumber(decimal: balance)
        wallet.income = NSDecimalNumber(decimal: income)
        wallet.spendings = NSDecimalNumber(decimal: spendings)
        wallet.isHidden = isHidden
        return wallet
    }
    
    func makeApiModel() -> WalletApiModelShort {
        WalletApiModelShort(
            id: id,
            name: name,
            currency: currency.code,
            amountLimit: limit ?? 0,
            balance: balance,
            income: income,
            spendings: spendings,
            isHidden: isHidden ? 1 : 0
        )
    }

    func makeFullApiModel() -> WalletApiModel {
        WalletApiModel(id: id,
                       name: name,
                       amountLimit: limit,
                       balance: balance,
                       income: income,
                       spendings: spendings,
                       isHidden: isHidden ? 1 : 0,
                       currencyDto: currency.makeApiModel())
    }
    
}

extension WalletModel {
    static func makeSkeletonModel() -> WalletModel {
        WalletModel(id: 0, name: "", currency: .RUB, limit: 0, balance: 0,
                    income: 0, spendings: 0, isHidden: false, isSkeleton: true)
    }
    
    static func makeCleanModel(_ id: Int = 0) -> WalletModel {
        return WalletModel(
            id: id,
            name: "?????????? ??????????????",
            currency: CurrencyModel.RUB,
            limit: nil,
            balance: 0,
            income: 0,
            spendings: 0,
            isHidden: false
        )
        
    }
    
    static func makeTestModel(_ id: Int = 0) -> WalletModel {
        return WalletModel(
            id: id,
            name: "???????????????? ?????????????? ???\(id)",
            currency: CurrencyModel.RUB,
            limit: Decimal(Double.random(in: 100000...1000000)),
            balance: Decimal(Double.random(in: 10000...100000)),
            income: Decimal(Double.random(in: 10000...100000)),
            spendings: Decimal(Double.random(in: 10000...100000)),
            isHidden: Bool.random()
        )
    }
    
    static func fromApiModel(_ wallet: WalletApiModel) -> WalletModel? {
        guard let currencyDto = wallet.currencyDto else {
            return nil
        }
        return WalletModel(
            id: wallet.id,
            name: wallet.name,
            currency: CurrencyModel.fromApiModel(currencyDto),
            limit: wallet.amountLimit,
            balance: wallet.balance ?? 0,
            income: wallet.income ?? 0,
            spendings: wallet.spendings ?? 0,
            isHidden: wallet.isHidden != 0
        )
    }
}
