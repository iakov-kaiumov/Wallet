//
//  PersonModel.swift
//  Wallet
//

import Foundation
import CoreData

struct PersonModel: Transient {
    var id: Int
    
    var email: String?
    
    var personBalance: Decimal?
    
    var personIncome: Decimal?
    
    var personSpendings: Decimal?
    
    var isSkeleton: Bool = false
    
    func makePersistent(context: NSManagedObjectContext) -> CDPerson? {
        guard let email = email,
              let personBalance = personBalance,
              let personIncome = personIncome,
              let personSpendings = personSpendings else { return nil }
        let person = CDPerson(context: context)
        person.id = Int64(id)
        person.email = email
        person.balance = NSDecimalNumber(decimal: personBalance)
        person.income = NSDecimalNumber(decimal: personIncome)
        person.spendings = NSDecimalNumber(decimal: personSpendings)
        return person
    }
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
