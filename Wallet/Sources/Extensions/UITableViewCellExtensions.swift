//
//  UITableViewCellExtensions.swift
//  Wallet
//

import UIKit

extension UITableViewCell {
    func enabled(_ on: Bool) {
        self.isUserInteractionEnabled = on
        for view in contentView.subviews {
            self.isUserInteractionEnabled = on
            view.alpha = on ? 1 : 0.5
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
