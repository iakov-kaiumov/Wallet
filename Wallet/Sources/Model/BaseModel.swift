//
//  BaseModel.swift
//  Wallet
//
//  Created by Яков Каюмов on 10.08.2022.
//

import Foundation

protocol BaseModel: Codable {
    func generateTestModel(_ id: Int) -> BaseModel
    func generateTestModels() -> [BaseModel]
}
