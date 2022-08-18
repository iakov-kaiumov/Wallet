//
// CategoryApiModel.swift
//

import Foundation

public struct CategoryApiModel: Codable {
    public enum CategoryType: String, Codable {
        case income = "INCOME"
        case spending = "SPENDING"
    }
    public var id: Int?
    public var name: String
    public var type: CategoryType?
    public var color: String
    public var iconId: Int?
    
//    init(from decoder: Decoder) {
//        let container = try decoder.container(keyedBy: CodingKeys)
//        id = try? container
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case id, name, type, color, iconId
//    }
}
