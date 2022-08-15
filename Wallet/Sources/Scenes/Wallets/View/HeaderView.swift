//
//  HeaderView.swift
//  Wallet

import UIKit
import SnapKit

final class HeaderView: UIView {
    
    // MARK: - Types
    private lazy var balanceLabel: UILabel = makeTitleLabel(fontSize: 32, weight: .medium)
    
    private lazy var incomeLabel: UILabel = makeTitleLabel(fontSize: 16, weight: .medium)
    
    private lazy var expencesLabel: UILabel = makeTitleLabel(fontSize: 16, weight: .medium)
    
    private lazy var balanceTitleLabel: UILabel = makeTitleLabel(fontSize: 13, weight: .regular)
    
    private lazy var incomeTitleLabel: UILabel = makeTitleLabel(fontSize: 13, weight: .regular, opacity: 0.6)
    
    private lazy var expencesTitleLabel: UILabel = makeTitleLabel(fontSize: 13, weight: .regular, opacity: 0.6)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Public methods
    func configure(model: PersonModel) {
        balanceLabel.text = String(format: "%.2f ₽", model.personBalance ?? 0)
        incomeLabel.text = String(format: "%.2f ₽", model.personIncome ?? 0)
        expencesLabel.text = String(format: "%.2f ₽", model.personSpendings ?? 0)
    }
    
    // MARK: - Private Methods
    private func setup() {
        self.snp.makeConstraints {
            $0.height.equalTo(245)
        }
        
        setupBalanceTitleLabel()
        setupBalanceLabel()
        setupMoneyStack()
        
        self.backgroundColor = R.color.accentPurple()
    }
    
    private func setupBalanceLabel() {
        balanceLabel.text = "0 ₽"
        addSubview(balanceLabel)
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.snp.makeConstraints {
            $0.top.equalTo(balanceTitleLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(16)
        }
    }
    
    private func setupBalanceTitleLabel() {
        balanceTitleLabel.text = R.string.localizable.wallets_balance()
        addSubview(balanceTitleLabel)
        balanceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(95)
            $0.leading.equalToSuperview().offset(16)
        }
    }
    
    private func setupMoneyStack() {
        incomeLabel.text = "0 ₽"
        incomeTitleLabel.text = R.string.localizable.wallets_income()
        expencesLabel.text = "0 ₽"
        expencesTitleLabel.text = R.string.localizable.wallets_expences()
        let incomeStackView = makeStackViewWithContent(dotColor: .green, titleLabel: incomeTitleLabel, moneyLabel: incomeLabel)
        let expencesStackView = makeStackViewWithContent(dotColor: .red, titleLabel: expencesTitleLabel, moneyLabel: expencesLabel)
        
        let moneyStackView = UIStackView()
        moneyStackView.addArrangedSubview(incomeStackView)
        moneyStackView.addArrangedSubview(expencesStackView)
        moneyStackView.axis = .horizontal
        moneyStackView.distribution = .fillEqually
        moneyStackView.alignment = .center
        
        addSubview(moneyStackView)
        moneyStackView.translatesAutoresizingMaskIntoConstraints = false
        moneyStackView.snp.makeConstraints {
            $0.top.equalTo(balanceLabel.snp.bottom).offset(24)
            $0.leading.right.equalToSuperview().offset(16)
        }
    }
    
    private func makeTitleLabel(fontSize: CGFloat, weight: UIFont.Weight, opacity: Float = 1) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = .white
        label.layer.opacity = opacity
        return label
    }
    
    private func makeStackViewWithContent(dotColor: DotColor, titleLabel: UILabel, moneyLabel: UILabel) -> UIStackView {
        let titleStackView = UIStackView()
        titleStackView.axis = .horizontal
        titleStackView.spacing = 6
        titleStackView.alignment = .center
        let dotLabel = DotView(color: dotColor)
        titleStackView.addArrangedSubview(dotLabel)
        titleStackView.addArrangedSubview(titleLabel)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .top
        
        stackView.addArrangedSubview(titleStackView)
        stackView.addArrangedSubview(moneyLabel)
        return stackView
    }
    
}
