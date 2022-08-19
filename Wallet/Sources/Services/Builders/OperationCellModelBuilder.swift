//
//  OperationCellModelBuilder.swift
//  Wallet
//

import UIKit

protocol OperationCellModelBuilderProtocol {
    func buildOperationCellModel(from operationModel: OperationModel, currency: CurrencyModel) -> OperationCellView.Model
    
    func buildSkeletonCellModel() -> OperationCellView.Model
}

final class OperationCellModelBuilder: OperationCellModelBuilderProtocol {
    func buildOperationCellModel(from operationModel: OperationModel, currency: CurrencyModel) -> OperationCellView.Model {
        guard let category = operationModel.category,
              let categoryType = category.type,
              let money = operationModel.operationBalance,
              let categoryTitle = category.name else {
            return OperationCellView.Model.makeTestModel()
        }
        let operationType = categoryType.displayName()
        let moneySpend = categoryType == .SPENDING ? "-" + money.displayString(currency: currency) : money.displayString(currency: currency)
        
        let timestamp = DateFormatter.hoursMinutes.string(from: operationModel.operationDate)
        
        var iconModel: IconView.IconModel?
        if let colorId = operationModel.category?.colorId,
           let iconId = operationModel.category?.iconId {
            let color = UIColor(named: "Color-" + String(colorId))
            let icon = UIImage(named: "Icon-" + String(iconId))
            
            iconModel = IconView.IconModel(icon: icon, backgroundColor: color)
        }
        
        return OperationCellView.Model(id: operationModel.id,
                                       walletId: operationModel.walletId,
                                       title: categoryTitle,
                                       operationType: operationType,
                                       moneySpend: moneySpend,
                                       timestamp: timestamp,
                                       icon: iconModel)
    }
    
    func buildSkeletonCellModel() -> OperationCellView.Model {
        return OperationCellView.Model.makeSkeleton()
    }
    
}
    
