//
//  CurrenciesModel.swift
//  Wallet

import Foundation

struct CurrencyModel {
    let code: String
    let symbol: String
    let fullDescription: String
    let shortDescription: String
    let value: Double
    
    var isAscending: Bool
    var isSkeleton: Bool = false
}

extension CurrencyModel {
    static func fromApiModel(_ apiModel: CurrencyApiModel) -> CurrencyModel {
        CurrencyModel(
            code: apiModel.code,
            symbol: apiModel.symbol,
            fullDescription: apiModel.fullDescription,
            shortDescription: apiModel.shortDescription,
            value: apiModel.value, isAscending: false
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
