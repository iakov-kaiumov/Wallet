//
//  IconViewModelBuilder.swift
//  Wallet
//

import UIKit

class IconViewModelBuilder {
    func build(
        _ model: CategoryModel,
        iconAlignment: IconCell.IconAlignment = .trailing
    ) -> IconCell.IconCellModel {
        let icon = UIImage(named: "Icon-" + String(model.iconId ?? 0))
        let iconViewModel = IconView.IconModel(
            icon: icon,
            backgroundColor: UIColor(named: "Color-" + String(model.colorId ?? 0))
        )
        return IconCell.IconCellModel(title: model.name, icon: iconViewModel, iconAlignment: iconAlignment)
    }
    
    func build(
        _ model: NewCategoryItem,
        iconAlignment: IconCell.IconAlignment = .trailing
    ) -> IconCell.IconCellModel {
        let icon = UIImage(named: "Icon-" + String(model.iconId))
        let iconViewModel = IconView.IconModel(
            icon: icon,
            backgroundColor: UIColor(named: "Color-" + String(model.colorId))
        )
        return IconCell.IconCellModel(title: model.title, icon: iconViewModel, iconAlignment: iconAlignment)
    }
}
