//
//  WalletDetailsViewModel.swift
//  Wallet
//

import Foundation

final class WalletDetailesViewModel {
    // MARK: - Properties
    typealias Dependencies = HasSpendChipModelBuilder & HasOperationCellModelBuilder
    
    var onDidUpdateWalletInfo: (() -> Void)?
    var onDidUpdateOperations: (() -> Void)?
    
    var walletInfoModel: OperationTableHeaderView.Model?
    var operationSections: [OperationCellSection] = []
    var walletAmount: String?
    var walletName: String?
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Public Methods
    func load() {
        loadWalletInfo()
        loadOperations()
    }
    
    // MARK: - Private Methods
    private func loadWalletInfo() {
        // TODO: - Load info from Network, replace stubs
        let income = Decimal(130_000)
        let incomeChipModel = dependencies.spendChipModelBuilder.buildIncomeSpendChipModel(income: income)
        
        let spent = Decimal(120_000)
        let limit = Decimal(100_000)
        
        let walletAmount = Decimal(200_000)
        let walletName = "Кошелек 1"
        self.walletAmount = walletAmount.displayString()
        self.walletName = walletName
        let expenseChipModel = dependencies.spendChipModelBuilder.buildExpenseSpendChipModel(spending: spent,
                                                                                       limit: limit)
        walletInfoModel = OperationTableHeaderView.Model(walletName: walletName,
                                                    walletAmount: walletAmount.displayString(),
            incomeChipModel: incomeChipModel,
                                                  expenseChipModel: expenseChipModel,
                                                  isLimitExceeded: true)
        onDidUpdateWalletInfo?()
    }
    
    private func loadOperations() {
        // TODO: - Load operations from Network, replace stubs
        operationSections = []
        // first section
        var firstSectionsModels: [OperationCellView.Model] = []
        for _ in 0..<5 {
            let model = OperationModel.makeTestModel()
            let cellModel = dependencies.operationCellModelBuilder.buildOperationCellModel(from: model)
            firstSectionsModels.append(cellModel)
        }
        operationSections.append(OperationCellSection(sectionName: "Сегодня",
                                                      operationModels: firstSectionsModels))
        
        // second section
        var secondSectionsModels: [OperationCellView.Model] = []
        for _ in 0..<7 {
            let model = OperationModel.makeTestModel()
            let cellModel = dependencies.operationCellModelBuilder.buildOperationCellModel(from: model)
            secondSectionsModels.append(cellModel)
        }
        operationSections.append(OperationCellSection(sectionName: "Вчера",
                                                      operationModels: secondSectionsModels))
        
        onDidUpdateOperations?()
    }
    
}
