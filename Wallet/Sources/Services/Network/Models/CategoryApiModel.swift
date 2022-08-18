//
// CategoryApiModel.swift
//

import Foundation

struct CategoryApiModel: Codable {
    let id: Int?
    let name: String
    let type: MoneyOperationType?
    let color: String
    let iconId: Int?
    
    var categoryModel: CategoryModel? {
        guard let id = id,
              let type = type,
              let color = Int(color),
              let iconId = iconId else { return nil }
        return CategoryModel(id: id,
                             name: name,
                             type: type,
                             colorId: color,
                             iconId: iconId)
    }
}
