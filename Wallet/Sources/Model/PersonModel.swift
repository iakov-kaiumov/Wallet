//
//  PersonModel.swift
//  Wallet
//

import Foundation

struct PersonModel: Codable {
    var id: Int
    
    var email: String?
    
    var personBalance: Decimal = 0
    
    var personIncome: Decimal = 0
    
    var personSpendings: Decimal = 0
    
    var isSkeleton: Bool = false
}

extension PersonModel {
    static func makeTestModel() -> PersonModel {
        PersonModel(
            id: 0,
            email: "test@example.com",
            personBalance: 100_000,
            personIncome: 100_000,
            personSpendings: 100_000
        )
    }
    
    static var skeletonModel: PersonModel {
        PersonModel(
            id: 0,
            email: "",
            personBalance: 100_000,
            personIncome: 100_000,
            personSpendings: 100_000,
            isSkeleton: true
        )
    }
    
    static func fromApiModel(_ apiModel: PersonApiModel) -> PersonModel {
        PersonModel(
            id: apiModel.id ?? 0,
            email: apiModel.email,
            personBalance: apiModel.balance ?? 0,
            personIncome: apiModel.income ?? 0,
            personSpendings: apiModel.spendings ?? 0
        )
    }
}
