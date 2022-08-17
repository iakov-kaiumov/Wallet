//
//  CategoryModel.swift
//  Wallet
//

import Foundation

enum CategoryType: String, Codable, CaseIterable {
    case INCOME, SPENDING
}

struct CategoryModel: Codable {
    var id: Int?
    
    var name: String?
    
    var type: CategoryType?
    
    var colorId: Int?
    
    var iconId: Int?
    
    static func getTestModel(_ id: Int = 0) -> CategoryModel {
        return CategoryModel(
            id: id,
            name: "Категория №\(id)",
            type: Bool.random() ? CategoryType.INCOME : CategoryType.SPENDING,
            colorId: Int.random(in: 0...5),
            iconId: Int.random(in: 0...5)
        )
    }
    
    static func newCategory() -> CategoryModel {
        CategoryModel(
            id: 0,
            name: "Новая категория",
            type: .INCOME,
            colorId: Int.random(in: 0...5),
            iconId: Int.random(in: 0...15)
        )
    }
}
