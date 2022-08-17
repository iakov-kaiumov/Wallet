//
//  AppDependency.swift
//  Wallet
//

import Foundation

// MARK: Has Protocols
protocol HasSpendChipModelBuilder {
    var spendChipModelBuilder: SpendChipModelBuilder { get }
}

protocol HasSignInService {
    var signInService: ISignInService { get }
}

protocol HasPersonNetworkServiceProtocol {
    var personNetworkService: PersonNetworkServiceProtocol { get }
}

final class AppDependency {
    private let signIn: SignInService
    
    private let proxyService: ProxyService
    
    // Builders
    private let spendChipBuilder: SpendChipModelBuilder
    
    init() {
        let networkService = NetworkService()
        let cacheService = CacheService()
        self.signIn = SignInService()
        self.proxyService = ProxyService(networkService: networkService,
                                         cacheService: cacheService)
        self.spendChipBuilder = SpendChipModelBuilder()
    }
}

// MARK: - HasSpendChipModelBuilder
extension AppDependency: HasSpendChipModelBuilder {
    var spendChipModelBuilder: SpendChipModelBuilder {
        return spendChipBuilder
    }
}

// MARK: - HasSignInService
extension AppDependency: HasSignInService {
    var signInService: ISignInService {
        return signIn
    }
}

// MARK: - HasPersonNetworkServiceProtocol
extension AppDependency: HasPersonNetworkServiceProtocol {
    var personNetworkService: PersonNetworkServiceProtocol {
        proxyService
    }
}
