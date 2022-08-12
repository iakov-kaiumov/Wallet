//
//  CurrenciesView.swift
//  Wallet
//
//  Created by Ярослав Ульяненков on 11.08.2022.
//

import UIKit

class CurrenciesView: UIView {
    
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
}
