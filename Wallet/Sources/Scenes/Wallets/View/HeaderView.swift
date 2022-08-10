//
//  HeaderView.swift
//  Wallet

import UIKit
import SnapKit

class HeaderView: UIView {
    
    // MARK: - Types
    lazy var balanceLabel: UILabel = getTitleLabel(fontSize: 32, weight: UIFont.Weight.regular)
    
    lazy var incomeLabel: UILabel = getTitleLabel(fontSize: 16, weight: UIFont.Weight.regular)
    
    lazy var expencesLabel: UILabel = getTitleLabel(fontSize: 16, weight: UIFont.Weight.regular)
    
    lazy var balanceTitleLabel: UILabel = getTitleLabel(fontSize: 16, weight: UIFont.Weight.light)
    
    lazy var incomeTitleLabel: UILabel = getTitleLabel(fontSize: 16, weight: UIFont.Weight.light, opacity: 0.6)
    
    lazy var expencesTitleLabel: UILabel = getTitleLabel(fontSize: 16, weight: UIFont.Weight.light, opacity: 0.6)
    
    // MARK: - Init
    init(frame: CGRect, balance: String?, income: String?, expences: String?) {
        super.init(frame: frame)
        balanceLabel.text = balance
        balanceTitleLabel.text = "Общий баланс"
        incomeLabel.text = income
        incomeTitleLabel.text = "Общий доход"
        expencesLabel.text = expences
        expencesTitleLabel.text = "Общий расход"
        
        let redDotLabel = getColoredDot(color: .red)
        let greenDotLabel = getColoredDot(color: .green)
        
        [balanceLabel, incomeLabel, expencesLabel, balanceTitleLabel, incomeTitleLabel, expencesTitleLabel, redDotLabel, greenDotLabel].forEach {
            addSubview($0)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(245)
        }
        
        self.backgroundColor = UIColor(named: "purpleBackground")
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func getTitleLabel(fontSize: CGFloat, weight: UIFont.Weight, opacity: Float = 1) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.layer.opacity = opacity
        return label
    }
    
    private func getColoredDot(color: DotColor) -> UILabel {
        let label = UILabel()
        label.text = "•"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = color == .red ? UIColor(named: "redDot") : UIColor(named: "greenDot")
        return label
    }
    
}

enum DotColor {
    case red
    case green
}
