//
//  UILabel.swift
//  Wallet
//

import UIKit

extension UILabel {
    func setText(_ text: String, animated: Bool = true) {
        if animated {
            self.defaultTransition {
                self.text = text
            }
        } else {
            self.text = text
        }
    }
}

extension UIView {
    func defaultTransition(_ animations: @escaping () -> Void) {
        UIView.transition(
            with: self,
            duration: 0.33,
            options: .transitionCrossDissolve,
            animations: animations
        )
    }
}
