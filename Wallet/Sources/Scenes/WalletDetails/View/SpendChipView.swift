//
//  SpendChipView.swift
//  Wallet
//

import UIKit

final class SpendChipView: UIView {
    struct Model {
        enum SpendMoneyTextType {
            case normal(String)
            case attributed(NSAttributedString)
        }
        let dotColor: DotColor
        let titleLabelText: String
        let spendMoneyText: SpendMoneyTextType
    }
    
    // MARK: – Properties
    private var model: Model?
    
    private let indicatorView = DotView()
    private let titleLabel = UILabel()
    private let spendMoneyLabel = UILabel()
    
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
        update()
    }
    
    // MARK: – Private Methods
    private func update() {
        guard let model = model else {
            return
        }
        indicatorView.setColor(color: model.dotColor)
        titleLabel.text = model.titleLabelText
        switch model.spendMoneyText {
        case .attributed(let text):
            spendMoneyLabel.attributedText = text
        case .normal(let text):
            spendMoneyLabel.text = text
        }
    }
    
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
        spendMoneyLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        spendMoneyLabel.textColor = R.color.background()
        spendMoneyLabel.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(indicatorView.snp.bottom).inset(-16)
            $0.bottom.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
}
