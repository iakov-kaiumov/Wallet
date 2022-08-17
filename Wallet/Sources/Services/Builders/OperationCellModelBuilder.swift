//
//  OperationCellModelBuilder.swift
//  Wallet
//

import UIKit

protocol OperationCellModelBuilderProtocol {
    func buildOperationCellModel(from operationModel: OperationModel) -> OperationCellView.Model
    
    func buildSkeletonCellModel() -> OperationCellView.Model
}

final class OperationCellModelBuilder: OperationCellModelBuilderProtocol {
    func buildOperationCellModel(from operationModel: OperationModel) -> OperationCellView.Model {
        guard let category = operationModel.category,
              let categoryType = category.type,
              let money = operationModel.operationBalance,
              let operationDate = operationModel.operationDate,
              let categoryTitle = category.name else {
            return OperationCellView.Model.makeTestModel()
        }
        let operationType = categoryType.displayName()
        let moneySpend = categoryType == .SPENDING ? "-" + money.displayString() : money.displayString()
        let timestamp = DateFormatter.hoursMinutes.string(from: operationDate)
        // TODO: - Get icon
        let icon = R.image.settingsButton()
        return OperationCellView.Model(title: categoryTitle,
                                       operationType: operationType,
                                       moneySpend: moneySpend,
                                       timestamp: timestamp,
                                       icon: icon)
    }
    
    func buildSkeletonCellModel() -> OperationCellView.Model {
        return OperationCellView.Model.makeSkeleton()
    }
    
}
    
