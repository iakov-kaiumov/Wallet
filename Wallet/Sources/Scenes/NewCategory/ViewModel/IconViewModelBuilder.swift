//
//  IconViewModelBuilder.swift
//  Wallet
//
//  Created by Ярослав Ульяненков on 15.08.2022.
//

import UIKit

class IconViewModelBuilder {
    func build(_ model: NewCategoryItemIcon) -> IconCell.IconCellModel {
        let icon = UIImage(named: "Icon-" + String(model.iconId))
        let iconViewModel = IconView.IconModel(icon: icon, backgroundColor: UIColor(named: "Color-" + String(model.colorId)))
        return IconCell.IconCellModel(title: model.title, icon: iconViewModel)
    }
}
