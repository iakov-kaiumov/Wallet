//
//  CurrenciesViewModel.swift
//  Wallet
//

import Foundation

protocol CurrenciesViewModelDelegate: AnyObject {
    func currenciesViewModelCloseButtonDidTap()
    
    func currenciesViewModelValueChanged(_ value: CurrencyType?)
}

class CurrenciesViewModel {
    
    private let mainCurrencies: [CurrencyType] = [.RUB, .USD, .EUR]
    
    private let allCurrencies: [CurrencyType] = CurrencyType.allCases
    
    var currencies: [CurrencyType] = [.RUB, .USD, .EUR]
    
    var chosenIndex: Int? {
        didSet {
            if let chosenIndex = chosenIndex {
                let type = allCurrencies[chosenIndex]
                delegate?.currenciesViewModelValueChanged(type)
            } else {
                delegate?.currenciesViewModelValueChanged(nil)
            }
        }
    }
    
    var isShortMode: Bool = true
    
    var onDataInserted: ((_ at: [IndexPath]) -> Void)?
    
    var onDataDeleted: ((_ at: [IndexPath]) -> Void)?
    
    weak var delegate: CurrenciesViewModelDelegate?
    
    func setCurrentCurrency(_ value: CurrencyType) {
        chosenIndex = allCurrencies.firstIndex(of: value)
    }
    
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
    
    func closeButtonDidTap() {
        delegate?.currenciesViewModelCloseButtonDidTap()
    }
    
    func nextButtonDidTap() {
        if let chosenIndex = chosenIndex {
            let type = allCurrencies[chosenIndex]
            delegate?.currenciesViewModelValueChanged(type)
        } else {
            delegate?.currenciesViewModelValueChanged(nil)
        }
    }
}
