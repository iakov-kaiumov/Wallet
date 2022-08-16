//
//  IconCollectionViewCell.swift
//  Wallet

import UIKit
import SnapKit

final class IconCollectionViewCell: UICollectionViewCell {
    
    struct Model {
        var isActive: Bool
        var iconModel: IconView.IconModel
    }
    
    // MARK: - Properties
    
    private lazy var iconView = IconView(edge: 40.0)
    static let reuseIdentifier = "IconCollectionViewCell"
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func configure(_ model: Model) {
        iconView.configure(model.iconModel)
        if model.isActive {
            layer.borderColor = model.iconModel.backgroundColor?.cgColor
        } else {
            layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    // MARK: - Private methods
    
    private func setup() {
        setupIconView()
        layer.borderWidth = 3
        layer.borderColor = .none
        layer.cornerRadius = frame.width / 2
    }
    
    private func setupIconView() {
        addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
