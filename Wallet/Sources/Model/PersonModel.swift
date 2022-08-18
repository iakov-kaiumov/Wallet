//
//  PersonModel.swift
//  Wallet
//

import Foundation
import CoreData

struct PersonModel: Codable, Transient {
    var id: Int
    
    var email: String?
    
    var personBalance: Decimal?
    
    var personIncome: Decimal?
    
    var personSpendings: Decimal?
    
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
    
    static func makeTestModel() -> PersonModel {
        return PersonModel(
            id: 0,
            email: "test@example.com",
            personBalance: Decimal(Double.random(in: 10000...100000)),
            personIncome: Decimal(Double.random(in: 10000...100000)),
            personSpendings: Decimal(Double.random(in: 10000...100000))
        )
    }
}
