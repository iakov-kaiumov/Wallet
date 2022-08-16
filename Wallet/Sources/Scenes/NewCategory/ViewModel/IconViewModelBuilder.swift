//
//  IconViewModelBuilder.swift
//  Wallet
//
//  Created by Ярослав Ульяненков on 15.08.2022.
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
}
