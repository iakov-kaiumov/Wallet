//
//  WalletDetailsViewModel.swift
//  Wallet
//

import Foundation

protocol WalletDetailesViewModelDelegate: AnyObject {
    func walletDetailsViewModelAddOperation()
    
    func walletDetailsViewModelOpenSettings()
}

final class WalletDetailesViewModel {
    // MARK: - Properties
    typealias Dependencies = HasSpendChipModelBuilder & HasOperationCellModelBuilder
    
    var onDidUpdateWalletInfo: (() -> Void)?
    var onDidUpdateOperations: (() -> Void)?
    var onDidDeleteOperaion: ((_ indexPath: IndexPath) -> Void)?
    var onDidDeleteSection: ((_ section: Int) -> Void)?
    
    var walletInfoModel: OperationTableHeaderView.Model?
    var operationSections: [OperationCellSection] = []
    var walletAmount: String?
    var walletName: String?
    
    weak var delegate: WalletDetailesViewModelDelegate?
    
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
    
    func addOperationButtonDidTap() {
        delegate?.walletDetailsViewModelAddOperation()
    }
    
    func settingButtonDidTap() {
        delegate?.walletDetailsViewModelOpenSettings()
    }
    
    func deleteOperation(at indexPath: IndexPath) {
        operationSections[indexPath.section].operationModels.remove(at: indexPath.row)
        if operationSections[indexPath.section].operationModels.count == 0 {
            operationSections.remove(at: indexPath.section)
            onDidDeleteSection?(indexPath.section)
        } else {
            onDidDeleteOperaion?(indexPath)
        }
        
    }
    
    // MARK: - Private Methods
    private func loadWalletInfo() {
        // TODO: - Load info from Network, replace stubs
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else {
                return
            }
            let income = Decimal(130_000)
            let incomeChipModel = self.dependencies.spendChipModelBuilder.buildIncomeSpendChipModel(income: income)
            
            let spent = Decimal(120_000)
            let limit = Decimal(100_000)
            
            let walletAmount = Decimal(200_000)
            let walletName = "Кошелек 1"
            self.walletAmount = walletAmount.displayString()
            self.walletName = walletName
            let expenseChipModel = self.dependencies.spendChipModelBuilder.buildExpenseSpendChipModel(
                spending: spent,
                limit: limit
            )
            self.walletInfoModel = OperationTableHeaderView.Model(
                walletName: walletName,
                walletAmount: walletAmount.displayString(),
                incomeChipModel: incomeChipModel,
                expenseChipModel: expenseChipModel,
                isLimitExceeded: true
            )
            self.onDidUpdateWalletInfo?()
        }
    }
    
    private func setMockupOperation() {
        self.operationSections = []
        // first section
        let models: [OperationCellView.Model] = (0..<3).map { _ in 
            self.dependencies.operationCellModelBuilder.buildSkeletonCellModel()
        }
        self.operationSections.append(
            OperationCellSection(sectionName: "", operationModels: models)
        )
        
        onDidUpdateOperations?()
    }
    
    private func loadOperations() {
        // TODO: - Load operations from Network, replace stubs
        setMockupOperation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else {
                return
            }
            self.operationSections = []
            // first section
            var firstSectionsModels: [OperationCellView.Model] = []
            for _ in 0..<5 {
                let model = OperationModel.makeTestModel()
                let cellModel = self.dependencies.operationCellModelBuilder.buildOperationCellModel(from: model)
                firstSectionsModels.append(cellModel)
            }
            self.operationSections.append(OperationCellSection(sectionName: "Сегодня",
                                                          operationModels: firstSectionsModels))
            
            // second section
            var secondSectionsModels: [OperationCellView.Model] = []
            for _ in 0..<7 {
                let model = OperationModel.makeTestModel()
                let cellModel = self.dependencies.operationCellModelBuilder.buildOperationCellModel(from: model)
                secondSectionsModels.append(cellModel)
            }
            self.operationSections.append(OperationCellSection(sectionName: "Вчера",
                                                          operationModels: secondSectionsModels))
            
            self.onDidUpdateOperations?()
        }
        
    }
    
}
