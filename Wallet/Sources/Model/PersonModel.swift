//
//  PersonModel.swift
//  Wallet
//

import Foundation

struct PersonModel: Codable {
    var id: Int
    
    var email: String?
    
    var personBalance: Double?
    
    var personIncome: Double?
    
    var personSpendings: Double?
    
    static func makeTestModel() -> PersonModel {
        return PersonModel(
            id: 0,
            email: "test@example.com",
            personBalance: Double.random(in: 10000...100000),
            personIncome: Double.random(in: 10000...100000),
            personSpendings: Double.random(in: 10000...100000)
        )
    }
}
