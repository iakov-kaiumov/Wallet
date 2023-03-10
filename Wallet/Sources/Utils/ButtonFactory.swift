//
//  ButtonFactory.swift
//  Wallet
//

import Foundation
import UIKit

class ButtonFactory {
    static func makeGrayButton() -> UIButton {
        let button = UIButton(type: .system)
        button.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = R.color.loginButton()
        button.setTitleColor(.white, for: .normal)
        
        return button
    }

}
