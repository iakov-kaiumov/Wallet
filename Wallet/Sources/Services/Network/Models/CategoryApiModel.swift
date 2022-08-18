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
//    public var id: Int?
//    public var name: String
//    public var type: CategoryType?
//    public var color: String
//    public var iconId: Int?
    
//    init(from decoder: Decoder) {
//        let container = try decoder.container(keyedBy: CodingKeys)
//        id = try? container
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case id, name, type, color, iconId
//    }
}
