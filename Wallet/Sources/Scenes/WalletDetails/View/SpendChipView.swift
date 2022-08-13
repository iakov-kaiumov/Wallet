//
//  SpendChipView.swift
//  Wallet
//

import UIKit

final class SpendChipView: UIView {
    struct Model {
        let indicatorColor: UIColor
        let titleLabelText: String
        let spendMoneyText: String
        let maxAmountSpendMoneyText: String?
        
    }
    // MARK: – Properties
    private var model: Model?
    
    private let indicatorView = UIView()
    private let titleLabel = UILabel()
    private let spendMoneyLabel = UILabel()
    private let maxAmountSpendMoneyLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Public Methods
    func configure(with model: Model) {
        self.model = model
    }
    
    // MARK: – Private Methods
    private func setup() {
        backgroundColor = R.color.accentPurple()
        layer.cornerRadius = 8
        addSubview(indicatorView)
        addSubview(titleLabel)
        setupIndicatorView()
        setupTitleLabel()
        setupSpendMoneyLabel()
    }
    
    private func setupIndicatorView() {
        indicatorView.layer.cornerRadius = 4
        indicatorView.backgroundColor = .red
        indicatorView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalTo(titleLabel)
            $0.size.equalTo(8)
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Доход"
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.layer.opacity = 0.6
        titleLabel.textColor = R.color.background()
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(indicatorView.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualToSuperview().inset(8)
        }
    }
    
    private func setupSpendMoneyLabel() {
        addSubview(spendMoneyLabel)
        spendMoneyLabel.attributedText = makeSpendMoneyAttributedText(spentMoney: "51 000 ₽ ",
                                                                      limitMoney: "/ 70 000 ₽",
                                                                      isLimitExceeded: true)
        spendMoneyLabel.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(indicatorView.snp.bottom).inset(-16)
            $0.bottom.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func makeSpendMoneyAttributedText(spentMoney: String,
                                              limitMoney: String,
                                              isLimitExceeded: Bool) -> NSAttributedString {
        let spentMoneyAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: R.color.background() as Any
        ]
        let spentMoneyText = NSMutableAttributedString(string: spentMoney,
                                                       attributes: spentMoneyAttributes)
        
        let limitMoneyAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold),
            .foregroundColor: isLimitExceeded ? R.color.warningRed() as Any : R.color.background() as Any
        ]
        
        let limitMoneyText = NSMutableAttributedString(string: limitMoney,
                                                       attributes: limitMoneyAttributes)
        spentMoneyText.append(limitMoneyText)
        return spentMoneyText
    }
    
}
