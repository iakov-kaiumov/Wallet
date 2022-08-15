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
    var signInService: SignInService { get }
}

final class AppDependency {
    private let spendChipBuilder = SpendChipModelBuilder()
    private let signIn = SignInService()
}

// MARK: Has Protocols Implementations
extension AppDependency: HasSpendChipModelBuilder {
    var spendChipModelBuilder: SpendChipModelBuilder {
        return spendChipBuilder
    }
}

extension AppDependency: HasSignInService {
    var signInService: SignInService {
        return signIn
    }
}
