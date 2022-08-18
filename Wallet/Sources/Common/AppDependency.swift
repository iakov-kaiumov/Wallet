//
//  AppDependency.swift
//  Wallet
//

import Foundation

// MARK: Has Protocols
protocol HasSignInService {
    var signInService: GoogleSignInServiceProtocol { get }
}

protocol HasWalletService {
    var walletService: WalletServiceProtocol { get }
}

protocol HasCategoryService {
    var categoryService: CategoryServiceProtocol { get }
}

protocol HasSpendChipModelBuilder {
    var spendChipModelBuilder: SpendChipBuilderProtocol { get }
}

protocol HasOperationCellModelBuilder {
    var operationCellModelBuilder: OperationCellModelBuilderProtocol { get }
}

// MARK: - AppDependency
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
extension AppDependency: HasWalletService {
    var walletService: WalletServiceProtocol {
        proxyService
    }
}

// MARK: - HasCategoryService
extension AppDependency: HasCategoryService {
    var categoryService: CategoryServiceProtocol {
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
