//
//  SpendChipBuilder.swift
//  Wallet
//

import UIKit

protocol SpendChipBuilderProtocol {
    func buildIncomeSpendChipModel(income: Decimal, currency: CurrencyModel) -> SpendChipView.Model
    func buildExpenseSpendChipModel(spending: Decimal, limit: Decimal?, currency: CurrencyModel) -> SpendChipView.Model
}

final class SpendChipModelBuilder: SpendChipBuilderProtocol {
    func buildIncomeSpendChipModel(income: Decimal, currency: CurrencyModel) -> SpendChipView.Model {
        let incomeMoney = income.displayString(currency: currency)
        let titleLabel = R.string.localizable.operations_income_chip()
        return SpendChipView.Model(dotColor: .green,
                                   titleLabelText: titleLabel,
                                   spendMoneyText: .normal(incomeMoney))
        
    }
    
    func buildExpenseSpendChipModel(spending: Decimal, limit: Decimal?, currency: CurrencyModel) -> SpendChipView.Model {
        let spentMoney = spending.displayString(currency: currency)
        let dotColor: DotColor = .red
        let titleLabel = R.string.localizable.operations_spendings_chip()
        guard let limit = limit, limit > 0 else {
            return SpendChipView.Model(dotColor: dotColor,
                                       titleLabelText: titleLabel,
                                       spendMoneyText: .normal(spentMoney))
        }
        let isLimitExceeded = spending > limit
        let limitString = " / " + limit.displayString(currency: currency)
        let attributedSpentMoney = makeSpendMoneyAttributedText(spentMoney: spentMoney,
                                                                limitMoney: limitString,
                                                                isLimitExceeded: isLimitExceeded)
        return SpendChipView.Model(dotColor: dotColor,
                                   titleLabelText: titleLabel,
                                   spendMoneyText: .attributed(attributedSpentMoney))

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
