//
//  HeaderView.swift
//  Wallet

import UIKit
import SnapKit

class HeaderView: UIView {
    
    // MARK: - Types
    lazy var balanceLabel: UILabel = getTitleLabel(fontSize: 32, weight: .medium)
    
    lazy var incomeLabel: UILabel = getTitleLabel(fontSize: 16, weight: .medium)
    
    lazy var expencesLabel: UILabel = getTitleLabel(fontSize: 16, weight: .medium)
    
    lazy var balanceTitleLabel: UILabel = getTitleLabel(fontSize: 13, weight: .regular)
    
    lazy var incomeTitleLabel: UILabel = getTitleLabel(fontSize: 13, weight: .regular, opacity: 0.6)
    
    lazy var expencesTitleLabel: UILabel = getTitleLabel(fontSize: 13, weight: .regular, opacity: 0.6)
    
    enum DotColor {
        case red
        case green
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        balanceLabel.text = "0 ₽"
        balanceTitleLabel.text = R.string.localizable.wallets_balance()
        incomeLabel.text = "0 ₽"
        incomeTitleLabel.text = R.string.localizable.wallets_income()
        expencesLabel.text = "0 ₽"
        expencesTitleLabel.text = R.string.localizable.wallets_expences()
        let moneyStack = getIncomeAndExpencesStackView()
        [balanceLabel, balanceTitleLabel, moneyStack].forEach {
            addSubview($0)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(245)
        }
        
        balanceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(95)
            $0.left.equalToSuperview().offset(16)
        }
        
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.snp.makeConstraints {
            $0.top.equalTo(balanceTitleLabel.snp.bottom).offset(6)
            $0.left.equalToSuperview().offset(16)
        }
        
        moneyStack.translatesAutoresizingMaskIntoConstraints = false
        moneyStack.snp.makeConstraints {
            $0.top.equalTo(balanceLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().offset(16)
        }
        
        self.backgroundColor = R.color.purpleBackground()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    public func setData(balance: Double?, income: Double?, expences: Double?) {
        if let balance = balance {
            balanceLabel.text = "\(balance) ₽"
        }
        
        if let income = income {
            incomeLabel.text = "\(income) ₽"
        }
        
        if let expences = expences {
            expencesLabel.text = "\(expences) ₽"
        }
    }
    
    // MARK: - Private Methods
    private func getTitleLabel(fontSize: CGFloat, weight: UIFont.Weight, opacity: Float = 1) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = .white
        label.layer.opacity = opacity
        return label
    }
    
    private func getColoredDot(color: DotColor) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        view.backgroundColor = color == .red ? R.color.redDot() : R.color.greenDot()
        view.layer.cornerRadius = 4
    
        view.translatesAutoresizingMaskIntoConstraints = false
        view.snp.makeConstraints {
            $0.width.equalTo(8)
            $0.height.equalTo(8)
        }
        return view
    }
    
    private func getIncomeAndExpencesStackView() -> UIStackView {
        let incomeStackView = getIncomeStackView()
        let expencesStackView = getExpencesStackView()
        
        let moneyStackView = UIStackView()
        moneyStackView.addArrangedSubview(incomeStackView)
        moneyStackView.addArrangedSubview(expencesStackView)
        moneyStackView.axis = .horizontal
        moneyStackView.distribution = .fillEqually
        moneyStackView.alignment = .center
        return moneyStackView
    }
    
    private func getIncomeStackView() -> UIStackView {
        return getStackViewWithContent(dotColor: .green, titleLabel: incomeTitleLabel, moneyLabel: incomeLabel)
    }
    
    private func getExpencesStackView() -> UIStackView {
        return getStackViewWithContent(dotColor: .red, titleLabel: expencesTitleLabel, moneyLabel: expencesLabel)
    }
    
    private func getStackViewWithContent(dotColor: DotColor, titleLabel: UILabel, moneyLabel: UILabel) -> UIStackView {
        let titleStackView = UIStackView()
        titleStackView.axis = .horizontal
        titleStackView.spacing = 6
        titleStackView.alignment = .center
        let dotLabel = getColoredDot(color: dotColor)
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
