//
//  WalletCell.swift
//  Wallet

import UIKit
import SnapKit

class WalletCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "Wallet Cell"

    var icon = UIImageView(image: R.image.walletBgIcon())
    var walletTitleLabel = UILabel()
    var walletBalanceLabel = UILabel()
    
    // MARK: - Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupIcon()
        setupWalletTitle()
        setupWalletBalance()
    }
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        walletTitleLabel.text = ""
        walletBalanceLabel.text = ""
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    }
    
    // MARK: - Public Methods
    public func configure(model: WalletModel) {
        walletTitleLabel.text = model.name
        walletBalanceLabel.text = String(format: "%.2f ₽", model.balance ?? 0)
    }
    
    // MARK: - Private Methods
    func setupIcon() {
        contentView.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview()
        }
    }
    
    func setupWalletTitle() {
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
    
    func setupWalletBalance() {
        
//        contentView.addSubview(walletBalanceLabel)
//        walletBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
//        walletBalanceLabel.snp.makeConstraints {
//            $0.trailing.equalToSuperview().inset(16)
//            $0.centerY.equalTo(contentView)
//        }
        
    }
}
