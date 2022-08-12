//
//  DefaultEditCell.swift
//  Wallet
//

import UIKit
import SnapKit

final class DefaultEditCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "DefaultEditCellIdentifier"
    
    private let titleLabel: UILabel = UILabel()
    private let subtitleLabel: UILabel = UILabel()
    
    // MARK: - Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    // MARK: - Private Methods
    private func setup() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.textColor = UIColor.label
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        titleLabel.numberOfLines = 1
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
        
        subtitleLabel.textColor = UIColor.secondaryLabel
        subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        subtitleLabel.numberOfLines = 1
        subtitleLabel.textAlignment = .right
    }
}
