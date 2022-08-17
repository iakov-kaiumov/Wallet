//
//  AppDependency.swift
//  Wallet
//

import Foundation

// MARK: Has Protocols
protocol HasSignInService {
    var signInService: GoogleSignInServiceProtocol { get }
}

protocol HasWalletServiceProtocol {
    var walletNetworkService: WalletServiceProtocol { get }
}

protocol HasSpendChipModelBuilder {
    var spendChipModelBuilder: SpendChipBuilderProtocol { get }
}

protocol HasOperationCellModelBuilder {
    var operationCellModelBuilder: OperationCellModelBuilderProtocol { get }
}

final class AppDependency {
    private let proxyService: ProxyService
    
    // Builders
    private let spendChipBuilder = SpendChipModelBuilder()
    private let operationCellBuilder = OperationCellModelBuilder()
    
    init() {
        let signInService = SignInService()
        let networkService = NetworkService(signInService: signInService)
        let cacheService = CacheService()
        self.proxyService = ProxyService(networkService: networkService,
                                         cacheService: cacheService)
    }
}

// MARK: - HasSignInService
extension AppDependency: HasSignInService {
    var signInService: GoogleSignInServiceProtocol {
        proxyService
    }
}

// MARK: - HasWalletServiceProtocol
extension AppDependency: HasWalletServiceProtocol {
    var walletNetworkService: WalletServiceProtocol {
        proxyService
    }
}

// MARK: HasSpendChipModelBuilder
extension AppDependency: HasSpendChipModelBuilder {
    var spendChipModelBuilder: SpendChipBuilderProtocol {
        return spendChipBuilder
    }
}

// MARK: OperationCellModelBuilder
extension AppDependency: HasOperationCellModelBuilder {
    var operationCellModelBuilder: OperationCellModelBuilderProtocol {
        return operationCellBuilder
    }
}
