//
//  WalletModel.swift
//  Wallet
//

import Foundation

enum CurrencyType: String, Codable, CaseIterable {
    case RUB, USD, EUR, CHF, KWD, BHD, OMR, JPY, SEK, GBR
    
    var currencySymbol: String {
        switch self {
        case .RUB:
            return "₽"
        default:
            return ""
        }
    }
}

struct WalletModel: Codable {
    var id: Int
    var personId: Int
    var name: String
    var currency: CurrencyType
    var limit: Decimal?
    var balance: Decimal
    var income: Decimal
    var spendings: Decimal
    var isHidden: Bool
    var formattedBalance: String {
        balance.displayString()
    }
    
    func makeApiModel() -> WalletApiModel {
        WalletApiModel(id: Int64(id),
                       personId: Int64(personId),
                       name: name,
                       currency: currency.rawValue,
                       amountLimit: limit,
                       balance: balance,
                       income: income,
                       spendings: spendings,
                       isHidden: isHidden)
    }
    
    static func makeCleanModel(_ id: Int = 0) -> WalletModel {
        return WalletModel(
            id: id,
            personId: 0,
            name: "Новый кошелек",
            currency: CurrencyType.RUB,
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
            personId: 0,
            name: "Тестовый кошелек №\(id)",
            currency: CurrencyType.RUB,
            limit: Decimal(Double.random(in: 100000...1000000)),
            balance: Decimal(Double.random(in: 10000...100000)),
            income: Decimal(Double.random(in: 10000...100000)),
            spendings: Decimal(Double.random(in: 10000...100000)),
            isHidden: Bool.random()
        )
    }
}
