//
//  OperationCellView.swift
//  Wallet
//

import UIKit

extension OperationCellView {
    static let uniqueIdentifier = String(describing: OperationCellView.self)
}

final class OperationCellView: UITableViewCell {
    struct Model {
        let title: String
        let operationType: String
        let moneySpend: String
        let timestamp: String
        let icon: UIImage?
        
        static func makeTestModel() -> Model {
            Model(title: "Супермаркеты",
                  operationType: "Траты",
                  moneySpend: "100 000 ₽",
                  timestamp: "15:00",
                  icon: R.image.settingsButton())
        }
    }
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let operationTypeLabel = UILabel()
    private let moneyLabel = UILabel()
    private let timestampLabel = UILabel()
    private let iconImageView = UIImageView()
    
    private var model: Model?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    // MARK: - Private Methods
    private func update() {
        guard let model = model else { return }
        titleLabel.text = model.title
        operationTypeLabel.text = model.operationType
        timestampLabel.text = model.timestamp
        moneyLabel.text = model.moneySpend
        iconImageView.image = model.icon
    }
    
    private func setup() {
        contentView.addSubview(moneyLabel)
        contentView.addSubview(titleLabel)
        setupIconImageView()
        setupTitleLabel()
        setupMoneyLabel()
        setupTimestampLabel()
        setupOperationTypeLabel()
    }
    
    private func setupIconImageView() {
        contentView.addSubview(iconImageView)
        // TODO: - Get rid of stub
        iconImageView.image = R.image.settingsButton()
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(40)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setupMoneyLabel() {
        moneyLabel.font = .systemFont(ofSize: 17)
        moneyLabel.textColor = R.color.mainText()
        moneyLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupTimestampLabel() {
        contentView.addSubview(timestampLabel)
        timestampLabel.font = .systemFont(ofSize: 13)
        timestampLabel.textColor = R.color.secondaryText()
        // TODO: Get rid of stub
        timestampLabel.text = "15:00"
        timestampLabel.snp.makeConstraints {
            $0.top.equalTo(moneyLabel.snp.bottom).inset(-8)
            $0.bottom.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = R.color.mainText()
        // TODO: - Get rid of stub
        titleLabel.text = "Супермаркеты"
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(16)
            $0.trailing.lessThanOrEqualTo(moneyLabel.snp.leading).inset(-16)
        }
    }
    
    private func setupOperationTypeLabel() {
        contentView.addSubview(operationTypeLabel)
        operationTypeLabel.font = .systemFont(ofSize: 13)
        operationTypeLabel.textColor = R.color.secondaryText()
        // TODO: - Get rid of stub
        operationTypeLabel.text = "Траты"
        operationTypeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-8)
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalTo(iconImageView.snp.trailing).inset(-16)
            $0.trailing.lessThanOrEqualTo(timestampLabel.snp.leading).inset(-16)
        }
    }
       
}
