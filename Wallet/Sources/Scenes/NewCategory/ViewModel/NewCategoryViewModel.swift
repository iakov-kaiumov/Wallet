//
//  NewCategoryViewModel.swift
//  Wallet

import UIKit

enum NewCategoryFieldType: Int {
    case name, type, icon
}

protocol NewCategoryItem {
    var type: NewCategoryFieldType { get }
    var title: String { get }
}

struct NewCategoryItemText: NewCategoryItem {
    var type: NewCategoryFieldType
    var title: String
    var value: String
}

struct NewCategoryItemIcon: NewCategoryItem {
    var type: NewCategoryFieldType
    var title: String
    var iconId: Int
}

final class NewCategoryViewModel {
    // MARK: - Properties
    var iconBuilder = IconViewModelBuilder()
    
    var tableItems: [NewCategoryItem] = [
        NewCategoryItemText(type: .name, title: R.string.localizable.newcategory_name(), value: "Новая категория"),
        NewCategoryItemText(type: .type, title: R.string.localizable.newcategory_type(), value: "Доход"),
        NewCategoryItemIcon(type: .icon, title: R.string.localizable.newcategory_icon(), iconId: 2)
    ]
}
