//
//  CategoryModel.swift
//  Wallet
//

import Foundation

struct CategoryModel: Codable {
    var id: Int?
    
    var name: String?
    
    var type: MoneyOperationType?
    
    var colorId: Int?
    
    var iconId: Int?
    
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
            name: "Новая категория",
            type: .INCOME,
            colorId: Int.random(in: 0...5),
            iconId: Int.random(in: 0...15)
        )
    }
}
