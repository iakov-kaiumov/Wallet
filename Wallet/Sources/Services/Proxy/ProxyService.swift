//
//  ProxyService.swift
//  Wallet
//

import Foundation
import SwiftKeychainWrapper

final class ProxyService {
    private let networkService = NetworkService()
}

protocol PersonProxyServiceProtocol: AnyObject {
    func createUser(email: String, completion: @escaping () -> Void)
    
    func getUserId() -> Int?
}

extension ProxyService: PersonProxyServiceProtocol {
    func getUserId() -> Int? {
        KeychainWrapper.standard.integer(forKey: "person.id")
    }
    
    func createUser(email: String, completion: @escaping () -> Void) {
        let userId = getUserId()
        if userId != nil {
            return
        }
        let person = PersonApiModel(email: email)
        networkService.createSelf(person) { result in
            switch result {
            case .success(let model):
                if let id = model.id {
                    KeychainWrapper.standard.set(Int(id), forKey: "person.id")
                }
            case .failure(let error):
                print(error)
            }
            completion()
        }
    }
}

protocol CategoryProxyServiceProtocol: AnyObject {
    func getCategories(for type: CategoryType, completion: @escaping ([CDCategory]) -> Void)
}

extension ProxyService: CategoryProxyServiceProtocol {
    func getCategories(for type: CategoryType, completion: @escaping ([CDCategory]) -> Void) {
        guard let personId = self.getUserId() else {
            return
        }
        var apiType: CategoryApiModel.CategoryType = .income
        if type == .SPENDING {
            apiType = .spending
        }
        networkService.categoryNetworkServiceGetAll(personId: personId, type: apiType) { result in
            switch result {
            case .success(let array):
                let categories: [CDCategory] = array.map {
                    let cat = CDCategory()
                    cat.id = $0.id ?? 0
                    cat.name = $0.name
                    cat.type = $0.type?.rawValue
                    cat.colorId = Int64($0.color) ?? 0
                    cat.iconId = $0.iconId ?? 0
                    return cat
                }
                completion(categories)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
}
