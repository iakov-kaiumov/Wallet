//
//  CurrenciesView.swift
//  Wallet
//
//  Created by Ярослав Ульяненков on 11.08.2022.
//

import UIKit
import SnapKit

class CurrenciesView: UIView {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 8
        self.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    func getCurrencyStack(currency: CurrenciesModel.Currency) -> UIStackView {
        let currencyNameLabel = UILabel()
        currencyNameLabel.font = .systemFont(ofSize: 13)
        currencyNameLabel.textColor = .systemGray
        currencyNameLabel.text = currency.type.rawValue
        
        let currencyValueLabel = UILabel()
        currencyValueLabel.font = .systemFont(ofSize: 13, weight: .light)
        currencyValueLabel.text = String(format: "%.2f", currency.value)
        
        let arrow = UIImageView(image: currency.isAscending ? R.image.greenArrow() : R.image.redArrow())
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        
        [currencyNameLabel, currencyValueLabel, arrow].forEach {
            stackView.addArrangedSubview($0)
        }
        
        return stackView
    }
    
    func configure(model: CurrenciesModel) {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        
        for currency in model.currencies {
            let currencyStack = getCurrencyStack(currency: currency)
            stack.addArrangedSubview(currencyStack)
        }
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}
