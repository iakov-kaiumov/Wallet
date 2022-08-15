//
//  AppDependency.swift
//  Wallet
//

import Foundation

// MARK: Has Protocols
protocol HasSpendChipModelBuilder {
    var spendChipModelBuilder: SpendChipModelBuilder { get }
}

final class AppDependency {
    private let spendChipBuilder = SpendChipModelBuilder()
    
}

// MARK: Has Protocols Implementations
extension AppDependency: HasSpendChipModelBuilder {
    var spendChipModelBuilder: SpendChipModelBuilder {
        return spendChipBuilder
    }
    
}
