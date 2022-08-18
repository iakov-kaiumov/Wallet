//
//  CurrenciesViewModel.swift
//  Wallet
//

import Foundation

protocol CurrenciesViewModelDelegate: AnyObject {
    func currenciesViewModelCloseButtonDidTap()
    
    func currenciesViewModelValueChanged(_ value: CurrencyModel?)
}

final class CurrenciesViewModel {
    
    private let mainCurrencies: [CurrencyModel] = []
    
    private let allCurrencies: [CurrencyModel] = []
    
    var currencies: [CurrencyModel] = []
    
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
    
    func setCurrentCurrency(_ value: CurrencyModel) {
        chosenIndex = allCurrencies.firstIndex(where: { $0.code == value.code })
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
    
    func getShowMoreCellModel() -> ShowMoreCell.Model {
        let text = isShortMode ? R.string.localizable.currencies_show_more_button() : R.string.localizable.currencies_show_less_button()
        
        return ShowMoreCell.Model(text: text, isShowMore: isShortMode)
    }
}
