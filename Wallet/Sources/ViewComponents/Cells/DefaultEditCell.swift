//
//  DefaultEditCell.swift
//  Wallet
//

import UIKit
import SnapKit

struct DefaultEditCellConfiguration {
    var title: String
    var subtitle: String = ""
    
    var titleFont: UIFont? = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
    var titleColor: UIColor? = .label
    
    var subtitleFont: UIFont? = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
    var subtitleColor: UIColor? = .secondaryLabel
}

final class DefaultEditCell: UITableViewCell {
    
    // MARK: - Properties
    private let titleLabel: UILabel = UILabel()
    private let subtitleLabel: UILabel = UILabel()
    
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
        subtitleLabel.text = ""
    }
    
    // MARK: - Public Methods
    func configure(with configuration: DefaultEditCellConfiguration) {
        titleLabel.textColor = configuration.titleColor
        titleLabel.font = configuration.titleFont
        titleLabel.text = configuration.title
        
        subtitleLabel.textColor = configuration.subtitleColor
        subtitleLabel.font = configuration.subtitleFont
        subtitleLabel.text = configuration.subtitle
    }
    
    // MARK: - Private Methods
    private func setup() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.numberOfLines = 1
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
        
        subtitleLabel.numberOfLines = 1
        subtitleLabel.textAlignment = .right
    }
}
