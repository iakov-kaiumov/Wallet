//
//  IconView.swift
//  Wallet

import UIKit
import SnapKit

final class IconView: UIView {
    
    struct IconModel {
        let icon: UIImage?
        let backgroundColor: UIColor?
    }
    
    // MARK: - Properties
    private lazy var imageView = UIImageView()
    private var edge: CGFloat
    
    // MARK: - Init
    
    init(edge: CGFloat) {
        self.edge = edge
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.edge = 0
        super.init(coder: coder)
    }
    
    // MARK: - Public methods
    func configure(_ model: IconModel?) {
        imageView.image = model?.icon
        backgroundColor = model?.backgroundColor
    }
    
    // MARK: - Private methods
    
    private func setup() {
        snp.makeConstraints {
            $0.height.width.equalTo(edge)
        }
        
        layer.cornerRadius = edge / 2.0
        
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints {
            $0.width.equalTo(edge * Constants.iconCoef)
            $0.height.width.equalTo(edge * Constants.iconCoef)
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - Constants

fileprivate extension Constants {
    static let iconCoef: CGFloat = 3 / 5
}
