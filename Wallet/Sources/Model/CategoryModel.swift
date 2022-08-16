//
//  CategoryModel.swift
//  Wallet
//

import Foundation

struct CategoryModel: Codable {
    var id: Int
    
    var name: String?
    
    var type: MoneyOperationType?
    
    var color: String?
    
    var iconId: Int?
    
    static func makeTestModel(_ id: Int = 0) -> CategoryModel {
        return CategoryModel(
            id: id,
            name: "Категория №\(id)",
            type: Bool.random() ? MoneyOperationType.INCOME : MoneyOperationType.SPENDING,
            color: "red",
            iconId: Int.random(in: 0...5)
        )
    }
}
