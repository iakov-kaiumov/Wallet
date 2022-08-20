//
//  WalletCell.swift
//  Wallet

import UIKit
import SnapKit

class WalletCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "Wallet Cell"
    private lazy var icon = UIImageView(image: R.image.walletBgIcon())
    private lazy var walletTitleLabel = UILabel()
    private lazy var walletBalanceLabel = UILabel()
    private lazy var redLabel = RedLabelView()
    
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
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    }
    
    override func prepareForReuse() {
        redLabel.layer.opacity = 0.0
        walletTitleLabel.text = ""
        walletBalanceLabel.text = ""
        super.prepareForReuse()
    }
    
    // MARK: - Public Methods
    func configure(model: WalletModel) {
        walletTitleLabel.text = model.name
        walletBalanceLabel.text = model.formattedBalance
        
        var isLimitExceeded = false
        if let limit = model.limit, limit > 0 {
            isLimitExceeded = model.spendings > limit
        }
        redLabel.layer.opacity = isLimitExceeded ? 1.0 : 0.0 // model.isLimitExceeded ? 1.0 : 0.0
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupIcon()
        setupWalletContent()
    }
    
    private func setupIcon() {
        contentView.addSubview(icon)
        icon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(20)
        }
    }
    
    private func setupWalletContent() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.addArrangedSubview(walletTitleLabel)
        stackView.addArrangedSubview(walletBalanceLabel)
        walletBalanceLabel.font = .systemFont(ofSize: 17)
        walletTitleLabel.font = .systemFont(ofSize: 17)
        walletBalanceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(icon.snp.trailing).offset(16)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        redLabel.layer.opacity = 0.0
        redLabel.setText(text: R.string.localizable.wallets_limit_exceeded())
        contentView.addSubview(redLabel)
        redLabel.snp.makeConstraints {
            $0.top.equalTo(walletTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(72)
        }
    }
}
