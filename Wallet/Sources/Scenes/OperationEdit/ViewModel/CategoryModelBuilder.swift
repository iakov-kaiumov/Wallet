//
//  CategoryModelBuilder.swift
//  Wallet

final class CategoryModelBuilder {
    func build(_ model: CategoryApiModel) -> CategoryModel {
                
        return CategoryModel(id: model.id, name: model.name, type: model.type, colorId: Int(model.color), iconId: model.iconId)
    }
    
    func build(_ models: [CategoryApiModel]) -> [CategoryModel] {
        return models.map { build($0) }
    }
}
