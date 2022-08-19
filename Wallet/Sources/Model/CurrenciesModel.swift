//
//  CurrenciesModel.swift
//  Wallet

import Foundation
import CoreData

struct CurrencyModel: Transient {
    let code: String
    let symbol: String
    let fullDescription: String
    let shortDescription: String
    let value: Decimal
    
    var isAscending: Bool
    var isSkeleton: Bool = false
    
    func makePersistent(context: NSManagedObjectContext) -> CDCurrency? {
        let currency = CDCurrency(context: context)
        currency.code = code
        currency.symbol = symbol
        currency.full_description = fullDescription
        currency.short_description = shortDescription
        currency.value = NSDecimalNumber(decimal: value)
        currency.isAscending = isAscending
        return currency
    }
    
    func makeApiModel() -> CurrencyApiModel {
        CurrencyApiModel(code: code,
                         symbol: symbol,
                         fullDescription: fullDescription,
                         shortDescription: shortDescription,
                         value: value,
                         ascending: isAscending)
    }
}

extension CurrencyModel {
    static func fromApiModel(_ apiModel: CurrencyApiModel) -> CurrencyModel {
        CurrencyModel(
            code: apiModel.code,
            symbol: apiModel.symbol,
            fullDescription: apiModel.fullDescription,
            shortDescription: apiModel.shortDescription,
            value: apiModel.value,
            isAscending: apiModel.ascending
        )
    }
    
    static func makeSkeletonModel() -> CurrencyModel {
        CurrencyModel(
            code: "USD", symbol: "$",
            fullDescription: "", shortDescription: "",
            value: 75, isAscending: false, isSkeleton: true
        )
    }
    
    static var RUB: CurrencyModel {
        CurrencyModel(
            code: "RUB", symbol: "₽",
            fullDescription: "Российский рубль (RUB)",
            shortDescription: "Российский рубль",
            value: 1.0, isAscending: false
        )
    }
}
