//
//  ShowMoreCell.swift
//  Wallet

import UIKit
import SnapKit

final class ShowMoreCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "ShowMoreCellIdentifier"
    
    private let titleLabel: UILabel = UILabel()
    
    private let arrowImage: UIImageView = UIImageView()
    
    // MARK: - Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    // MARK: - Public Methods
    func configure(isShortMode: Bool) {
        titleLabel.text = isShortMode ? R.string.localizable.currencies_show_more_button() : R.string.localizable.currencies_show_less_button()
        arrowImage.image = isShortMode ? R.image.arrow_down() : R.image.arrow_up()
    }
    
    // MARK: - Private Methods
    private func setup() {
        contentView.addSubview(arrowImage)
        arrowImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(12.5)
        }
        arrowImage.contentMode = .scaleAspectFit
        arrowImage.tintColor = R.color.accentPurple()
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.greaterThanOrEqualTo(arrowImage.snp.leading).inset(16)
            $0.centerY.equalToSuperview()
        }
        titleLabel.textColor = R.color.accentPurple()
    }
}
