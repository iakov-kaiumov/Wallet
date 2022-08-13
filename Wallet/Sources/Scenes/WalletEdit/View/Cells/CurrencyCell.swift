//
//  CurrencyCell.swift
//  Wallet
//

import UIKit
import SnapKit

final class CurrencyCell: UITableViewCell {
    
    // MARK: - Properties
    private let titleLabel: UILabel = UILabel()
    
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
    }
    
    // MARK: - Public Methods
    func configure(type: CurrencyType) {
        titleLabel.text = type.rawValue
    }
    
    // MARK: - Private Methods
    private func setup() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.textColor = UIColor.label
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        titleLabel.numberOfLines = 1
    }
}
