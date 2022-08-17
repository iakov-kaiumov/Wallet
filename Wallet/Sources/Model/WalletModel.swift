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
    
    var name: String?

    var currency: CurrencyType?

    var limit: Double?

    var balance: Double?

    var income: Double?

    var spendings: Double?
    
    var isHidden: Bool
    
    var formattedBalance: String {
        String(format: "%.2f ₽", balance ?? 0)
    }
    
    static func getTestModel(_ id: Int = 0) -> WalletModel {
        return WalletModel(
            id: id,
            personId: 0,
            name: "Тестовый кошелек №\(id)",
            currency: CurrencyType.RUB,
            limit: Double.random(in: 100000...1000000),
            balance: Double.random(in: 10000...100000),
            income: Double.random(in: 10000...100000),
            spendings: Double.random(in: 10000...100000),
            isHidden: Bool.random()
        )
    }
}
