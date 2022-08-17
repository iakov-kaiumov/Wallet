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
    func createUser(email: String)
    
    func getUserId() -> Int?
}

extension ProxyService: PersonProxyServiceProtocol {
    func getUserId() -> Int? {
        KeychainWrapper.standard.integer(forKey: "person.id")
    }
    
    func createUser(email: String) {
        let userId = getUserId()
        if userId != nil {
            return
        }
        let person = PersonApiModel(email: email)
        networkService.createSelf(person) { result in
            switch result {
            case .success(let model):
                if let id = model.id {
                    KeychainWrapper.standard.set(id, forKey: "person.id")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

protocol CategoryProxyServiceProtocol: AnyObject {
    func getCategories(for type: CategoryType, completion: @escaping ([CategoryModel]) -> Void)
}

extension ProxyService: CategoryProxyServiceProtocol {
    func getCategories(for type: CategoryType, completion: @escaping ([CategoryModel]) -> Void) {
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
                let categories = array.map {
                    CategoryModel(
                        id: $0.id,
                        name: $0.name
                    )
                }
                completion(categories)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
}
