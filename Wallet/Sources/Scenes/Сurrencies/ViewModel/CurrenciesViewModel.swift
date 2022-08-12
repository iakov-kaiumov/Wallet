//
//  CurrenciesViewModel.swift
//  Wallet
//

import Foundation

class CurrenciesViewModel {
    
    private let mainCurrencies: [CurrencyType] = [.RUB, .USD, .EUR]
    
    private var allCurrencies: [CurrencyType] = []
    
    var currencies: [CurrencyType] = []
    
    var chosenIndex: Int?
    
    var isShortMode: Bool = true
    
    var onDataInserted: ((_ at: [IndexPath]) -> Void)?
    
    var onDataDeleted: ((_ at: [IndexPath]) -> Void)?
    
    func toggleState() {
        isShortMode.toggle()
        if isShortMode {
            let changedAt = (mainCurrencies.count..<allCurrencies.count).map {
                IndexPath(row: $0, section: 0)
            }
            currencies = mainCurrencies
            onDataDeleted?(changedAt)
        } else {
            let changedAt = (mainCurrencies.count..<allCurrencies.count).map {
                IndexPath(row: $0, section: 0)
            }
            currencies = allCurrencies
            onDataInserted?(changedAt)
        }
        
    }
    
    func loadTestData() {
        allCurrencies = CurrencyType.allCases
        currencies = mainCurrencies
    }
}
