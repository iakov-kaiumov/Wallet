//
//  CategoryModel.swift
//  Wallet
//

import Foundation
import CoreData

struct CategoryModel: Codable, Transient {
    var id: Int?
    
    var name: String?
    
    var type: MoneyOperationType?
    
    var colorId: Int?
    
    var iconId: Int?
    
    func makeApiModel() -> CategoryApiModel? {
        guard let name = name,
              let colorId = colorId else { return nil }
        return CategoryApiModel(id: id,
                                name: name,
                                type: type,
                                color: String(colorId),
                                iconId: iconId)
    }
    
    func makePersistent(context: NSManagedObjectContext) -> CDCategory? {
        guard let id = id,
              let colorId = colorId,
              let iconId = iconId else { return nil }
        let category = CDCategory(context: context)
        category.id = Int64(id)
        category.name = name
        category.type = type?.rawValue
        category.colorId = Int64(colorId)
        category.iconId = Int64(iconId)
        return category
    }
    
    static func makeTestModel(_ id: Int = 0) -> CategoryModel {
        return CategoryModel(
            id: id,
            name: "Категория №\(id)",
            type: Bool.random() ? MoneyOperationType.INCOME : MoneyOperationType.SPENDING,
            colorId: Int.random(in: 0...5),
            iconId: Int.random(in: 0...5)
        )
    }
    
    static func newCategory() -> CategoryModel {
        CategoryModel(
            id: 0,
            name: "",
            type: .INCOME,
            colorId: Int.random(in: 0...5),
            iconId: Int.random(in: 0...15)
        )
    }
}
