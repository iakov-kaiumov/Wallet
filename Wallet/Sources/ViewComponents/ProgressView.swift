//
//  ProgressView.swift
//  Wallet
//

import UIKit

class ProgressView: UIView {
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        snp.makeConstraints {
            $0.width.height.equalTo(60)
        }
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        activityIndicator.color = R.color.accentPurple()
        activityIndicator.startAnimating()
        
        alpha = 0.0
    }
    
    func show() {
        UIView.animate(
            withDuration: 0.33,
            delay: 0.0,
            options: [.transitionCrossDissolve],
            animations: {
                self.alpha = 1.0
            },
            completion: nil
        )
    }
    
    func hide() {
        UIView.animate(
            withDuration: 0.33,
            delay: 0.0,
            options: [.transitionCrossDissolve],
            animations: {
                self.alpha = 0.0
            },
            completion: nil
        )
    }
}
