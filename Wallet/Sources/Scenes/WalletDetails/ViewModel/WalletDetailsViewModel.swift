//
//  WalletDetailsViewModel.swift
//  Wallet
//

import Foundation

final class WalletDetailesViewModel {
    // MARK: - Properties
    typealias Dependencies = HasSpendChipModelBuilder
    
    var onDidUpdateIncomeChip: (() -> Void)?
    var onDidUpdateExpenseChip: (() -> Void)?
    
    var incomeChipModel: SpendChipView.Model?
    var expenseChipModel: SpendChipView.Model?
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Public Methods
    func load() {
        // TODO: - Load chips from Network, replace stubs
        let income = Decimal(130_000)
        incomeChipModel = dependencies.spendChipModelBuilder.buildIncomeSpendChipModel(income: income)
        
        let spent = Decimal(120_000)
        let limit = Decimal(100_000)
        expenseChipModel = dependencies.spendChipModelBuilder.buildExpenseSpendChipModel(spending: spent,
                                                                                       limit: limit)
        onDidUpdateIncomeChip?()
        onDidUpdateExpenseChip?()
    }
}
