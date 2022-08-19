//
//  SpendChipContainerView.swift
//  Wallet
//

import UIKit

final class OperationTableHeaderView: UITableViewHeaderFooterView {
    struct Model {
        let walletName: String
        let walletAmount: String
        let incomeChipModel: SpendChipView.Model
        let expenseChipModel: SpendChipView.Model
        let isLimitExceeded: Bool
    }
    // MARK: - Properties
    private let walletNameLabel = UILabel()
    private let walletAmountLabel = UILabel()
    private let incomeChipView = SpendChipView()
    private let expenseChipView = SpendChipView()
    private let chipsContainer = UIStackView()
    private let wholeContainer = UIStackView()
    private let limitLabel = UILabel()
    
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Public Methods
    func configure(with model: Model?) {
        walletAmountLabel.showSkeleton(model == nil)
        limitLabel.showSkeleton(model == nil)
        incomeChipView.showSkeleton(model == nil)
        expenseChipView.showSkeleton(model == nil)
        
        if let model = model {
            incomeChipView.configure(with: model.incomeChipModel)
            expenseChipView.configure(with: model.expenseChipModel)
            walletAmountLabel.setText(model.walletAmount)
            walletNameLabel.setText(model.walletName)
            UIView.defaultTransition(with: limitLabel) { [weak self] in
                self?.limitLabel.isHidden = !model.isLimitExceeded
            }
        }
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupWalletNameLabel()
        setupWalletAmountLabel()
        setupVerticalContainer()
        setupChipsContainer()
        setupLimitLabel()
    }
    
    private func setupWalletNameLabel() {
        contentView.addSubview(walletNameLabel)
        walletNameLabel.text = "Кошелек 1"
        walletNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        walletNameLabel.numberOfLines = 2
        walletNameLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupWalletAmountLabel() {
        contentView.addSubview(walletAmountLabel)
        walletAmountLabel.text = "-"
        walletAmountLabel.font = .systemFont(ofSize: 32, weight: .semibold)
        walletAmountLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(walletNameLabel.snp.bottom).offset(16)
        }
        
        walletAmountLabel.setupSkeleton(cornerRadius: 8)
    }
    
    private func setupVerticalContainer() {
        contentView.addSubview(wholeContainer)
        
        wholeContainer.axis = .vertical
        wholeContainer.distribution = .fill
        wholeContainer.spacing = 8
        
        wholeContainer.snp.makeConstraints {
            $0.top.equalTo(walletAmountLabel.snp.bottom).inset(-16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func setupChipsContainer() {
        wholeContainer.addArrangedSubview(chipsContainer)
        chipsContainer.axis = .horizontal
        chipsContainer.distribution = .fillEqually
        chipsContainer.spacing = 8
        chipsContainer.addArrangedSubview(incomeChipView)
        chipsContainer.addArrangedSubview(expenseChipView)
        
        incomeChipView.setupSkeleton(cornerRadius: 7)
        expenseChipView.setupSkeleton(cornerRadius: 7)
    }
    
    private func setupLimitLabel() {
        wholeContainer.addArrangedSubview(limitLabel)
        limitLabel.font = .systemFont(ofSize: 17)
        limitLabel.textColor = R.color.warningRed()
        limitLabel.backgroundColor = R.color.warningRed()?.withAlphaComponent(0.08)
        limitLabel.layer.masksToBounds = true
        limitLabel.layer.cornerRadius = 8
        limitLabel.textAlignment = .center
        
        limitLabel.text = R.string.localizable.operations_limit_label()
        limitLabel.snp.makeConstraints {
            $0.height.equalTo(52)
        }
        
        limitLabel.setupSkeleton(cornerRadius: 8)
    }
    
}
