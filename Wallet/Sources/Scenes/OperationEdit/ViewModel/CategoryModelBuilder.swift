//
//  CategoryModelBuilder.swift
//  Wallet

final class CategoryModelBuilder {
    func build(_ model: CategoryApiModel) -> CategoryModel {
        var type: MoneyOperationType
        switch model.type {
        case .spending:
            type = .SPENDING
        case .income:
            type = .INCOME
        default:
            type = .INCOME
        }
                
        return CategoryModel(id: model.id, name: model.name, type: type, colorId: Int(model.color), iconId: model.iconId)
    }
    
    func build(_ models: [CategoryApiModel]) -> [CategoryModel] {
        return models.map { build($0) }
    }
}
