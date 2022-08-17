//
//  IconCollectionViewCellModelBuilder.swift
//  Wallet

import UIKit

final class IconCollectionViewCellModelBuilder {
    func build(_ model: IconPickerViewModel.Item) -> IconCollectionViewCell.Model {
        var icon: UIImage?
        var color: UIColor?
        if let colorId = model.color {
            color = UIColor(named: "Color-" + String(colorId))
        }
        
        if let iconId = model.icon {
            icon = UIImage(named: "Icon-" + String(iconId))
        }
        
        let iconViewModel = IconView.IconModel(icon: icon, backgroundColor: color)
        return IconCollectionViewCell.Model(isActive: model.isActive, iconModel: iconViewModel)
    }
}
