//
//  UIView+ApplyBlur.swift
//  Wallet
//

import UIKit

extension UIView {
    func applyBlur() {
        let effect = UIBlurEffect(style: .systemThickMaterial)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = bounds
        blurView.isUserInteractionEnabled = false
        
        let blurLayerMask = CAGradientLayer()
        blurLayerMask.frame = blurView.bounds
        blurLayerMask.colors = [UIColor.red.withAlphaComponent(0).cgColor,
                                UIColor.red.withAlphaComponent(0.8).cgColor]
        blurLayerMask.startPoint = CGPoint(x: 0, y: 0)
        blurLayerMask.endPoint = CGPoint(x: 0, y: 0.5)
        
        blurView.layer.mask = blurLayerMask
        addSubview(blurView)
    }
}
