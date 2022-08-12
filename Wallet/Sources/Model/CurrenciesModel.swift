//
//  CurrenciesModel.swift
//  Wallet

import Foundation

struct CurrenciesModel {
    
    var currencies: [Currency] = []
    
    struct Currency {
        var type: CurrencyType
        var value: Double
        var isAscending: Bool
    }
    
    static func getTestModel() -> CurrenciesModel {
        var model = CurrenciesModel()
        
        for currency in [CurrencyType.USD, CurrencyType.EUR, CurrencyType.GBR] {
            model.currencies.append(Currency(type: currency, value: Double.random(in: 50...100), isAscending: Bool.random()))
        }
        
        return model
    }
}
