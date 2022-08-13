//
//  WalletCell.swift
//  Wallet

import UIKit
import SnapKit

class WalletCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "Wallet Cell"

    private var icon = UIImageView(image: R.image.walletBgIcon())
    private var walletTitleLabel = UILabel()
    private var walletBalanceLabel = UILabel()
    
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
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    }
    
    override func prepareForReuse() {
        walletTitleLabel.text = ""
        walletBalanceLabel.text = ""
        super.prepareForReuse()
    }
    
    // MARK: - Public Methods
    func configure(model: WalletModel) {
        walletTitleLabel.text = model.name
        walletBalanceLabel.text = model.formattedBalance
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupIcon()
        setupWalletContent()
    }
    
    private func setupIcon() {
        contentView.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview()
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.snp.makeConstraints {
            $0.leading.equalTo(icon.snp.trailing).offset(16)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}
