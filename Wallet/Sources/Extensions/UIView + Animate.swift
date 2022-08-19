//
//  UILabel.swift
//  Wallet
//

import UIKit

extension UILabel {
    func setText(_ text: String, animated: Bool = true) {
        if animated {
            UIView.defaultTransition(with: self) {
                self.text = text
            }
        } else {
            self.text = text
        }
    }
}

extension UIView {
    static func defaultTransition(with view: UIView, animations: @escaping () -> Void) {
        UIView.transition(
            with: view,
            duration: 0.33,
            options: .transitionCrossDissolve,
            animations: animations
        )
    }
}
