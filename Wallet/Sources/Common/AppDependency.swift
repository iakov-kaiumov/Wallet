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
    var signInService: GoogleSignInServiceProtocol { get }
}

protocol HasPersonNetworkServiceProtocol {
    var personNetworkService: PersonNetworkServiceProtocol { get }
}

protocol HasWalletServiceProtocol {
    var walletNetworkService: WalletServiceProtocol { get }
}

final class AppDependency {
    private let proxyService: ProxyService
    
    // Builders
    private let spendChipBuilder: SpendChipModelBuilder
    
    init() {
        let signInService = SignInService()
        let networkService = NetworkService(signInService: signInService)
        let cacheService = CacheService()
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
    var signInService: GoogleSignInServiceProtocol {
        return proxyService
    }
}

// MARK: - HasPersonNetworkServiceProtocol
extension AppDependency: HasPersonNetworkServiceProtocol {
    var personNetworkService: PersonNetworkServiceProtocol {
        proxyService
    }
}

// MARK: - HasWalletServiceProtocol
extension AppDependency: HasWalletServiceProtocol {
    var walletNetworkService: WalletServiceProtocol {
        proxyService
    }
}
