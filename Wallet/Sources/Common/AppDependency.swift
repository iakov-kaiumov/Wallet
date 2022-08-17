//
//  AppDependency.swift
//  Wallet
//

import Foundation

// MARK: Has Protocols
protocol HasSignInService {
    var signInService: ISignInService { get }
}

protocol HasSpendChipModelBuilder {
    var spendChipModelBuilder: SpendChipBuilderProtocol { get }
}

protocol HasOperationCellModelBuilder {
    var operationCellModelBuilder: OperationCellModelBuilderProtocol { get }
}

final class AppDependency {
    private let signIn = SignInService()
    
    // Builders
    private let spendChipBuilder = SpendChipModelBuilder()
    private let operationCellBuilder = OperationCellModelBuilder()
}

// MARK: HasSignInService
extension AppDependency: HasSignInService {
    var signInService: ISignInService {
        return signIn
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
