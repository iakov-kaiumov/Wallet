//
//  OperationApiModelBuilder.swift
//  Wallet

final class OperationApiModelBuilder {
    func build(_ model: OperationModel) -> OperationApiModelToSend {
        
        return OperationApiModelToSend(type: model.type, balance: model.operationBalance, categoryId: model.category?.id, date: model.operationDate)
    }
}
