//
//  CurrenciesViewModel.swift
//  Wallet
//

import Foundation

protocol CurrenciesViewModelDelegate: AnyObject {
    func currenciesViewModelCloseButtonDidTap()
    
    func currenciesViewModelValueChanged(_ value: CurrencyModel)
    
    func currenciesViewModel(_ viewModel: CurrenciesViewModel, didReceiveError error: Error)
}

final class CurrenciesViewModel {
    // MARK: - Properties
    typealias Dependencies = HasCurrenciesService
    
    var currencies: [CurrencyModel] = []
    
    var currencyModel: CurrencyModel
    
    var isShortMode: Bool = true
    
    var onDataReload: (() -> Void)?
    
    var onDataInserted: ((_ at: [IndexPath]) -> Void)?
    
    var onDataDeleted: ((_ at: [IndexPath]) -> Void)?
    
    weak var delegate: CurrenciesViewModelDelegate?
    
    private var dependencies: Dependencies
    
    private var mainCurrencies: [CurrencyModel] = []
    
    private var allCurrencies: [CurrencyModel] = []
    
    private let mainCurrenciesCodes: [String] = ["RUB", "USD", "EUR"]
    
    // MARK: - Init
    init(dependencies: Dependencies, currencyModel: CurrencyModel) {
        self.dependencies = dependencies
        self.currencyModel = currencyModel
        
        loadCurrencies()
    }
    
    // MARK: - Public methods
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
        delegate?.currenciesViewModelValueChanged(currencyModel)
    }
    
    func getShowMoreCellModel() -> ShowMoreCell.Model {
        let text = isShortMode ? R.string.localizable.currencies_show_more_button() : R.string.localizable.currencies_show_less_button()
        
        return ShowMoreCell.Model(text: text, isShowMore: isShortMode)
    }
    
    // MARK: - Private methods
    private func loadCurrencies() {
        dependencies.currenciesNetworkService.currenciesServiceGetAll { result in
            switch result {
            case .success(let models):
                self.setupCurrencies(models)
            case .failure(let error):
                self.delegate?.currenciesViewModel(self, didReceiveError: error)
            }
        }
    }
    
    private func setupCurrencies(_ apiModels: [CurrencyApiModel]) {
        let allCurrencies = apiModels.map { CurrencyModel.fromApiModel($0) }
        let mainCurrencies = allCurrencies.filter { mainCurrenciesCodes.contains($0.code) }
        let extraCurrencies = allCurrencies.filter { !mainCurrenciesCodes.contains($0.code) }
        let sortedCurrencies = mainCurrencies + extraCurrencies
        DispatchQueue.main.async { [weak self] in
            self?.allCurrencies = sortedCurrencies
            self?.mainCurrencies = mainCurrencies
            self?.currencies = mainCurrencies
            self?.onDataReload?()
        }
    }
}
