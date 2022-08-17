//
//  NewCategoryViewModel.swift
//  Wallet

import UIKit

enum NewCategoryFieldType: Int {
    case name, type, icon
}

struct NewCategoryItem {
    var type: NewCategoryFieldType
    var title: String
    var value: String = ""
    var iconId: Int = 0
    var colorId: Int = 0
}

protocol NewCategoryViewModelDelegate: AnyObject {
    func newCategoryViewModelEnterName(_ currentValue: String?)
    
    func newCategoryViewModelEnterType(_ currentValue: MoneyOperationType)
    
    func newCategoryViewModelEnterIcon()
    
    func newCategoryViewModelCreateCategory(_ newCategory: CategoryModel)
}

final class NewCategoryViewModel {
    // MARK: - Properties
    var model: CategoryModel
    
    var onItemChanged: ((_ row: Int) -> Void)?
    
    weak var delegate: NewCategoryViewModelDelegate?
    
    var tableItems: [NewCategoryItem] = []
    
    lazy var iconBuilder = IconViewModelBuilder()
    
    private lazy var formatter: INewCategoryViewModelFormatter = NewCategoryViewModelFormatter()
    
    init(model: CategoryModel) {
        self.model = model
        loadData()
    }
    
    func loadData() {
        tableItems = [
            NewCategoryItem(type: .name,
                            title: R.string.localizable.newcategory_name(),
                            value: formatter.formatName(model)),
            NewCategoryItem(type: .type,
                            title: R.string.localizable.newcategory_type(),
                            value: formatter.formatType(model)),
            NewCategoryItem(type: .icon,
                            title: R.string.localizable.newcategory_icon(),
                            iconId: model.iconId ?? 0, colorId: model.colorId ?? 0)
        ]
        tableItems.indices.forEach { onItemChanged?($0) }
    }
    
    func itemIndex(for type: NewCategoryFieldType) -> Int? {
        return tableItems.firstIndex(where: { $0.type == type })
    }
    
    func cellDidTap(at indexPath: IndexPath) {
        let item = tableItems[indexPath.row]
        switch item.type {
        case .name:
            delegate?.newCategoryViewModelEnterName(model.name)
        case .type:
            delegate?.newCategoryViewModelEnterType(model.type ?? .INCOME)
        case .icon:
            delegate?.newCategoryViewModelEnterIcon()
        }
    }
    
    func changeName(_ value: String?) {
        guard let index = itemIndex(for: .name) else { return }
        model.name = value
        tableItems[index].value = formatter.formatName(model)
        onItemChanged?(index)
    }
    
    func changeType(_ value: MoneyOperationType?) {
        guard let index = itemIndex(for: .type) else { return }
        model.type = value
        tableItems[index].value = formatter.formatType(model)
        onItemChanged?(index)
    }
    
    func changeIcon(iconId: Int, colorId: Int) {
        model.colorId = colorId
        model.iconId = iconId
        tableItems[2].value = formatter.formatType(model)
        onItemChanged?(2)
    }
    
    func createCategory() {
        delegate?.newCategoryViewModelCreateCategory(model)
    }
}
