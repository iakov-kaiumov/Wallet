//
//  CategoryModel.swift
//  Wallet
//

import Foundation

enum CategoryType: String, Codable {
    case INCOME, SPENDING
}

struct CategoryModel: Codable {
    var id: Int?
    
    var name: String?
    
    var type: CategoryType?
    
    var color: String?
    
    var iconId: Int?
    
    static func getTestModel(_ id: Int = 0) -> CategoryModel {
        return CategoryModel(
            id: id,
            name: "Категория №\(id)",
            type: Bool.random() ? CategoryType.INCOME : CategoryType.SPENDING,
            color: "red",
            iconId: Int.random(in: 0...5)
        )
    }
}
