//
//  OperationViewModel.swift
//  Wallet
//

import Foundation

enum OperationEditFieldType: Int {
    case amount, type, category, date
}

struct OperationEditTableItem {
    var type: OperationEditFieldType
    var title: String
    var value: String
}

protocol OperationViewModelDelegate: AnyObject {
    func operationViewModelEnterAmount(_ currentValue: Decimal?)
    
    func operationViewModelEnterType(_ currentValue: MoneyOperationType)
    
    func operationViewModelEnterCategory(_ currentValue: CategoryModel?, _ currentType: MoneyOperationType)
    
    func operationViewModelDidFinish()
}

final class OperationViewModel {
    typealias Dependencies = HasOperationService
    
    // MARK: - Properties
    var model: OperationModel
    
    var isCreatingMode: Bool = true
    
    weak var delegate: OperationViewModelDelegate?
    
    var onItemChanged: ((_ row: Int) -> Void)?
    
    var setButtonInteraction: ((_ isActive: Bool) -> Void)?
    
    var tableItems: [OperationEditTableItem] = []
    
    private lazy var formatter: IOperationViewModelFormatter = OperationViewModelFormatter()
    private lazy var operationApiModelBuilder = OperationApiModelBuilder()
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies, model: OperationModel) {
        self.dependencies = dependencies
        self.model = model
        loadData()
    }

    // MARK: - Public
    func itemIndex(for type: OperationEditFieldType) -> Int? {
        return tableItems.firstIndex(where: { $0.type == type })
    }
    
    func loadData() {
        tableItems = [
            OperationEditTableItem(
                type: .amount,
                title: R.string.localizable.operation_edit_amount(),
                value: formatter.formatAmount(model)
            ),
            OperationEditTableItem(
                type: .type,
                title: R.string.localizable.operation_edit_type(),
                value: formatter.formatType(model)
            ),
            OperationEditTableItem(
                type: .category,
                title: R.string.localizable.operation_edit_category(),
                value: formatter.formatCategory(model)
            ),
            OperationEditTableItem(
                type: .date,
                title: R.string.localizable.operation_edit_date(),
                value: formatter.formatDate(model)
            )
        ]
        toggleButton()
        tableItems.indices.forEach { onItemChanged?($0) }
    }
    
    func cellDidTap(item: OperationEditTableItem) {
        switch item.type {
        case .amount:
            delegate?.operationViewModelEnterAmount(model.operationBalance)
        case .type:
            delegate?.operationViewModelEnterType(model.type ?? .INCOME)
        case .category:
            delegate?.operationViewModelEnterCategory(model.category, model.type ?? .INCOME)
        default:
            break
        }
    }
    
    func nextButtonDidTap() {
        let apiModel = operationApiModelBuilder.build(model)
        print(apiModel)
        dependencies.operationNetworkService.operationServiceCreate(apiModel, walletID: model.walletId) { [weak self] result in
            print(result)
            switch result {
            case .success(let model):
                print(model)
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self?.delegate?.operationViewModelDidFinish()
            }
        }
    }
    
    func changeAmount(_ value: Decimal?) {
        guard let index = itemIndex(for: .amount) else { return }
        model.operationBalance = value
        tableItems[index].value = formatter.formatAmount(model)
        toggleButton()
        onItemChanged?(index)
    }
    
    func changeType(_ value: MoneyOperationType?) {
        guard let index = itemIndex(for: .type) else { return }
        if model.type != value {
            model.category = nil
            tableItems[index + 1].value = formatter.formatCategory(model)
        }
        model.type = value
        tableItems[index].value = formatter.formatType(model)
        toggleButton()
        onItemChanged?(index)
    }
    
    func changeCategory(_ value: CategoryModel?) {
        guard let index = itemIndex(for: .category) else { return }
        model.category = value
        model.type = value?.type
        tableItems[index - 1].value = formatter.formatType(model)
        tableItems[index].value = formatter.formatCategory(model)
        toggleButton()
        onItemChanged?(index)
    }
    
    func changeDate(_ value: Date?) {
        guard let index = itemIndex(for: .date) else { return }
        model.operationDate = value ?? Date()
        tableItems[index].value = formatter.formatDate(model)
        toggleButton()
        onItemChanged?(index)
    }
    
    // MARK: - Private
    
    private func toggleButton() {
        guard let _ = model.operationBalance,
              let _ = model.type,
              let _ = model.category else {
            setButtonInteraction?(false)
            return
        }
        
        setButtonInteraction?(true)
    }
}
