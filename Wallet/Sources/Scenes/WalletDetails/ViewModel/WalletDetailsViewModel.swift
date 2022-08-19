//
//  WalletDetailsViewModel.swift
//  Wallet
//

import Foundation

protocol WalletDetailesViewModelDelegate: AnyObject {
    func walletDetailsViewModelAddOperation(wallet: WalletModel)
    
    func walletDetailsViewModelOpenSettings(wallet: WalletModel)
    
    func walletDetailsViewModel(_ viewModel: WalletDetailesViewModel, didReceiveError error: Error)
}

final class WalletDetailesViewModel {
    // MARK: - Properties
    typealias Dependencies = HasSpendChipModelBuilder & HasOperationCellModelBuilder & HasOperationService & HasWalletService
    
    var walletModel: WalletModel
    
    var onDidUpdateWalletInfo: (() -> Void)?
    var onDidUpdateOperations: (() -> Void)?
    var onDidDeleteOperaion: ((_ indexPath: IndexPath) -> Void)?
    var onDidDeleteSection: ((_ section: Int) -> Void)?
    
    var walletInfoModel: OperationTableHeaderView.Model?
    var operationSections: [OperationCellSection] = []
    
    weak var delegate: WalletDetailesViewModelDelegate?
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies, wallet: WalletModel) {
        self.dependencies = dependencies
        self.walletModel = wallet
        self.dependencies.operationNetworkService.addDelegate(self)
        self.dependencies.walletService.addDelegate(self)
    }
    
    // MARK: - Public Methods
    func load() {
        self.setMockupOperation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.loadWalletInfo()
            self.loadOperations()
        }
        
    }
    
    func addOperationButtonDidTap() {
        delegate?.walletDetailsViewModelAddOperation(wallet: walletModel)
    }
    
    func settingButtonDidTap() {
        delegate?.walletDetailsViewModelOpenSettings(wallet: walletModel)
    }
    
    func deleteOperation(at indexPath: IndexPath) {
        let model = operationSections[indexPath.section].operationModels[indexPath.row]
        dependencies.operationNetworkService.operationServiceDelete(walletId: model.walletId, operationId: model.id) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                self.delegate?.walletDetailsViewModel(self, didReceiveError: error)
            }
        }
        
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
        let incomeChipModel = dependencies.spendChipModelBuilder.buildIncomeSpendChipModel(
            income: walletModel.income,
            currency: walletModel.currency
        )
        
        let expenseChipModel = dependencies.spendChipModelBuilder.buildExpenseSpendChipModel(
            spending: walletModel.spendings,
            limit: walletModel.limit,
            currency: walletModel.currency
        )
        
        self.walletInfoModel = OperationTableHeaderView.Model(
            walletName: walletModel.name,
            walletAmount: walletModel.balance.displayString(currency: walletModel.currency),
            incomeChipModel: incomeChipModel,
            expenseChipModel: expenseChipModel,
            isLimitExceeded: walletModel.isLimitExceeded
        )
        self.onDidUpdateWalletInfo?()
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
        setMockupOperation()
        
        dependencies.operationNetworkService.operationServiceGetAll(walletID: walletModel.id) { result in
            switch result {
            case .success(let models):
                self.transformOperations(models)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.walletDetailsViewModel(self, didReceiveError: error)
                }
            }
            
        }
    }
    
    private func transformOperations(_ apiModels: [OperationApiModel]) {
        let operations = apiModels.compactMap { OperationModel.fromApiModel($0) }
        let sections = self.getSectionedOperations(operations)
        DispatchQueue.main.async {
            self.operationSections = sections
            self.onDidUpdateOperations?()
        }
    }
    
    private func getDescriptiveSectionName(from date: Date) -> String {
        // TODO: - Move to service
        let daysBetween = date.daysBetween(date: Date())
        switch daysBetween {
        case -1:
            return R.string.localizable.date_tommorow()
        case 0:
            return R.string.localizable.date_today()
        case 1:
            return R.string.localizable.date_yesterday()
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    private func getSectionedOperations(_ operations: [OperationModel]) -> [OperationCellSection] {
        let sortedOperations = operations.sorted(by: { $0.operationDate < $1.operationDate })
        var groupedItems = [[OperationModel]]()
        var tempItems = [OperationModel]()
        
        for operation in sortedOperations {
            if let firstOperation = tempItems.first {
                let daysBetween = firstOperation.operationDate.daysBetween(date: operation.operationDate)
                if daysBetween >= 1 {
                    groupedItems.append(tempItems.reversed())
                    tempItems.removeAll()
                    tempItems.append(operation)
                } else {
                    tempItems.append(operation)
                }
            } else {
                tempItems.append(operation)
            }
        }
        if !operations.isEmpty {
            groupedItems.append(tempItems.reversed())
        }
        
        var sections = [OperationCellSection]()
        for items in groupedItems.reversed() {
            
            let operationModels = items.map {
                dependencies.operationCellModelBuilder.buildOperationCellModel(from: $0, currency: walletModel.currency)
            }
            var sectionName = ""
            if let date = items.first?.operationDate {
                sectionName = getDescriptiveSectionName(from: date)
            }
            sections.append(OperationCellSection(sectionName: sectionName, operationModels: operationModels))
        }
        
        return sections
    }
}

extension WalletDetailesViewModel: OperationServiceDelegate {
    func operationService(_ service: OperationServiceProtocol, didLoadOperations operations: [OperationApiModel]) {
        transformOperations(operations)
    }
}

extension WalletDetailesViewModel: WalletServiceDelegate {
    func walletServiceDidConnectToInternet(_ service: WalletServiceProtocol) {
        load()
    }
    
    func walletService(_ service: WalletServiceProtocol, didLoadWallets wallets: [WalletApiModel]) {
        guard let newApiWallet = wallets.first(where: { $0.id == walletModel.id }),
              let newWalletModel = WalletModel.fromApiModel(newApiWallet) else {
            return
        }
        DispatchQueue.main.async {
            self.walletModel = newWalletModel
            self.loadWalletInfo()
        }
    }
}
