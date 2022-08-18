//
//  UIViewExtensions.swift
//  Wallet
//

import Foundation
import UIKit

extension UIView {
    func setupSkeleton(
        insets: UIEdgeInsets = .zero,
        cornerRadius: CGFloat = 16
    ) {
        if subviews.first(where: { $0.tag == -1}) != nil {
            return
        }
        let skView = SkeletonView(cornerRadius: cornerRadius)
        skView.tag = -1
        skView.layer.cornerRadius = cornerRadius
        
        addSubview(skView)
        
        skView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(insets.top)
            $0.bottom.equalToSuperview().inset(insets.bottom)
            $0.leading.equalToSuperview().inset(insets.left)
            $0.trailing.equalToSuperview().inset(insets.right)
        }
//        skView.alpha = 0.0
    }
    
    func showSkeleton(_ on: Bool) {
        guard let skView = subviews.first(where: { $0.tag == -1}) else {
            return
        }
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: [.transitionCrossDissolve], animations: {
                skView.alpha = on ? 1.0 : 0.0
            },
            completion: nil
        )
        
        isUserInteractionEnabled = !on
    }
}

public class SkeletonView: UIView {
    private let startColors = [UIColor.systemGray5, UIColor.systemGray6, UIColor.systemGray5]
    
    private var gradient: CAGradientLayer?
    
    private let cornerRadius: CGFloat
    
    init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard gradient == nil else {
            gradient?.frame = bounds
            return
        }
        gradient = configuredGradientLayer()
        if let gradientLayer = gradient {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    private func configuredGradientLayer() -> CAGradientLayer {
        let startPoint = CGPoint(x: 0.0, y: 0.0)
        let endPoint = CGPoint(x: 1.0, y: 1.0)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = startColors.map(\.cgColor)
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds
        gradientLayer.type = .axial
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.locations = [0.0, -1.0, 1.0]
        
        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
        animation.fromValue = [0.0, -1.0, 1.0]
        animation.toValue = [0.0, 1.0, 1.0]
        animation.duration = 1.0
        animation.repeatCount = .infinity
        animation.autoreverses = true
        gradientLayer.add(animation, forKey: "animation")
        
        return gradientLayer
    }
}
