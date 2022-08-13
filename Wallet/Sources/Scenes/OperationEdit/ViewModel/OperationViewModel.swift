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
    func operationViewModelEnterAmount(_ currentValue: Double?)
    
    func operationViewModelEnterType(_ currentValue: OperationType?)
    
    func operationViewModelEnterCategory(_ currentValue: CategoryModel?)
    
    func operationViewModelEnterDate(_ currentValue: Date?)
    
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
                value: formatter.formatAmount(model.operationBalance)
            ),
            OperationEditTableItem(
                type: .type,
                title: R.string.localizable.operation_edit_type(),
                value: formatter.formatType(model.type)
            ),
            OperationEditTableItem(
                type: .category,
                title: R.string.localizable.operation_edit_category(),
                value: formatter.formatCategory(model.category)
            ),
            OperationEditTableItem(
                type: .date,
                title: R.string.localizable.operation_edit_date(),
                value: formatter.formatDate(model.operationDate)
            )
        ]
        tableItems.indices.forEach { onItemChanged?($0) }
    }
    
    func cellDidTap(item: OperationEditTableItem) {
        switch item.type {
        case .amount:
            delegate?.operationViewModelEnterAmount(model.operationBalance)
        case .type:
            delegate?.operationViewModelEnterType(model.type)
        case .category:
            delegate?.operationViewModelEnterCategory(model.category)
        default:
            break
        }
    }
    
    func nextButtonDidTap() {
        delegate?.operationViewModelDidFinish()
    }
    
    func changeAmount(_ value: Double?) {
        guard let index = itemIndex(for: .amount) else { return }
        model.operationBalance = value
        tableItems[index].value = formatter.formatAmount(value)
        onItemChanged?(index)
    }
    
    func changeType(_ value: OperationType?) {
        guard let index = itemIndex(for: .type) else { return }
        model.type = value
        tableItems[index].value = formatter.formatType(value)
        onItemChanged?(index)
    }
    
    func changeCategory(_ value: CategoryModel?) {
        guard let index = itemIndex(for: .category) else { return }
        model.category = value
        tableItems[index].value = formatter.formatCategory(value)
        onItemChanged?(index)
    }
    
    func changeDate(_ value: Date?) {
        print(value)
        guard let index = itemIndex(for: .date) else { return }
        model.operationDate = value
        tableItems[index].value = formatter.formatDate(value)
        onItemChanged?(index)
        print("changeDate \(tableItems[index].value)")
    }
}
