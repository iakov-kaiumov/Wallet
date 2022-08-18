//
// PersonApiModel.swift
//

import Foundation

struct PersonApiModel: Codable {
    init(id: Int64? = nil, email: String? = nil, balance: Decimal? = nil, income: Decimal? = nil, spendings: Decimal? = nil) {
        self.id = id
        self.email = email
        self.balance = balance
        self.income = income
        self.spendings = spendings
    }
    
    let id: Int64?
    let email: String?
    let balance: Decimal?
    let income: Decimal?
    let spendings: Decimal?
    
    enum CodingKeys: String, CodingKey {
        case id, email, balance, income, spendings
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decodeIfPresent(Int64.self,
                                            forKey: .id)
        email = try? container.decodeIfPresent(String.self,
                                               forKey: .email)
        balance = try? container.decodeIfPresent(Decimal.self,
                                                 forKey: .balance)
        income = try? container.decodeIfPresent(Decimal.self,
                                                forKey: .income)
        spendings = try? container.decodeIfPresent(Decimal.self,
                                                   forKey: .spendings)
         
    }
}
