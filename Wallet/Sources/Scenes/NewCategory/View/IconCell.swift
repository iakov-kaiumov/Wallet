//
//  IconCell.swift
//  Wallet

import UIKit
import SnapKit

final class IconCell: UITableViewCell {
    
    struct IconCellModel {
        var title: String?
        var icon: UIImage?
    }
    
    // MARK: - Properties
    private lazy var titleLabel: UILabel = UILabel()
    private lazy var iconView: IconView = IconView()
    
    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        iconView.configure(nil)
    }
    
    // MARK: - Public Methods
    func configure(_ model: IconCellModel) {
        titleLabel.text = model.title
        iconView.configure(model.icon)
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupTitle()
        setupIcon()
    }
    
    private func setupTitle() {
        titleLabel.textColor = UIColor.label
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        titleLabel.numberOfLines = 1
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setupIcon() {
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
        iconView.backgroundColor = R.color.purpleBackground()
    }
}
