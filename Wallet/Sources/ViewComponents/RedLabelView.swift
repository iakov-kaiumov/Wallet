//
//  RedLabelView.swift
//  Wallet

import UIKit
import SnapKit

final class RedLabelView: UIView {
    
    // MARK: - Properties
    
    private lazy var textLabel = UILabel()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Public methods
    
    func setText(text: String?) {
        textLabel.text = text
    }
    
    // MARK: - Private methods
    
    private func setup() {
        layer.masksToBounds = true
        layer.backgroundColor = R.color.warningRed()?.cgColor
        layer.cornerRadius = 9
        textLabelSetup()
    }
    
    private func textLabelSetup() {
        textLabel.textColor = .white
        textLabel.font = .systemFont(ofSize: 12)
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.bottom.equalToSuperview().inset(2)
            $0.leading.equalToSuperview().offset(6)
            $0.trailing.equalToSuperview().inset(6)
        }
    }
}
