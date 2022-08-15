//
//  IconView.swift
//  Wallet

import UIKit
import SnapKit

final class IconView: UIView {
    
    // MARK: - Properties
    private lazy var imageView = UIImageView()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public methods
    func configure(_ icon: UIImage?) {
        imageView.image = icon
    }
    
    // MARK: - Private methods
    
    private func setup() {
        snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.width.equalTo(30)
        }
        
        layer.cornerRadius = 15
        
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.equalTo(18)
            $0.height.width.equalTo(18)
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}
