//
//  IconCell.swift
//  Wallet

import UIKit
import SnapKit

final class IconCell: UITableViewCell {
    
    enum IconAlignment {
        case leading, trailing
    }
    
    struct IconCellModel {
        let title: String?
        let icon: IconView.IconModel
        let iconAlignment: IconAlignment
    }
    
    // MARK: - Properties
    private lazy var titleLabel: UILabel = UILabel()
    private lazy var iconView: IconView = IconView(edge: 40.0)
    
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
        switch model.iconAlignment {
        case .leading:
            setupIcon(alignment: model.iconAlignment)
            setupTitle(alignment: model.iconAlignment)
        case .trailing:
            setupTitle(alignment: model.iconAlignment)
            setupIcon(alignment: model.iconAlignment)
        }
        
        titleLabel.text = model.title
        iconView.configure(model.icon)
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupTitle(alignment: .trailing)
        setupIcon(alignment: .trailing)
    }
    
    private func setupTitle(alignment: IconAlignment) {
        titleLabel.removeFromSuperview()
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.removeConstraints()
        
        switch alignment {
        case .leading:
            titleLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(iconView.snp.trailing).offset(8)
            }
        case .trailing:
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(16)
                $0.centerY.equalToSuperview()
            }
        }
        
        titleLabel.textColor = UIColor.label
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        titleLabel.numberOfLines = 1
    }
    
    private func setupIcon(alignment: IconAlignment) {
        iconView.removeFromSuperview()
        contentView.addSubview(iconView)
        
        iconView.snp.removeConstraints()
        
        switch alignment {
        case .leading:
            iconView.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(16)
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(40)
            }
        case .trailing:
            iconView.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(16)
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
                $0.width.height.equalTo(40)
            }
        }
    }
}
