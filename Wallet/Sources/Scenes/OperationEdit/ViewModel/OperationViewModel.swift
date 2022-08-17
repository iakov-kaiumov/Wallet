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
    
    func operationViewModelEnterCategory(_ currentValue: CategoryModel?)
    
    func operationViewModelDidFinish()
}

final class OperationViewModel {
    // MARK: - Properties
    var model: OperationModel
    
    var isCreatingMode: Bool = true
    
    weak var delegate: OperationViewModelDelegate?
    
    var onItemChanged: ((_ row: Int) -> Void)?
    
    var tableItems: [OperationEditTableItem] = []
    
    private lazy var formatter: IOperationViewModelFormatter = OperationViewModelFormatter()
    
    // MARK: - Init
    init(model: OperationModel) {
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
        tableItems.indices.forEach { onItemChanged?($0) }
    }
    
    func cellDidTap(item: OperationEditTableItem) {
        switch item.type {
        case .amount:
            delegate?.operationViewModelEnterAmount(model.operationBalance)
        case .type:
            delegate?.operationViewModelEnterType(model.type ?? .INCOME)
        case .category:
            delegate?.operationViewModelEnterCategory(model.category)
        default:
            break
        }
    }
    
    func nextButtonDidTap() {
        delegate?.operationViewModelDidFinish()
    }
    
    func changeAmount(_ value: Decimal?) {
        guard let index = itemIndex(for: .amount) else { return }
        model.operationBalance = value
        tableItems[index].value = formatter.formatAmount(model)
        onItemChanged?(index)
    }
    
    func changeType(_ value: MoneyOperationType?) {
        guard let index = itemIndex(for: .type) else { return }
        model.type = value
        tableItems[index].value = formatter.formatType(model)
        onItemChanged?(index)
    }
    
    func changeCategory(_ value: CategoryModel?) {
        guard let index = itemIndex(for: .category) else { return }
        model.category = value
        tableItems[index].value = formatter.formatCategory(model)
        onItemChanged?(index)
    }
    
    func changeDate(_ value: Date?) {
        guard let index = itemIndex(for: .date) else { return }
        model.operationDate = value
        tableItems[index].value = formatter.formatDate(model)
        onItemChanged?(index)
    }
}
