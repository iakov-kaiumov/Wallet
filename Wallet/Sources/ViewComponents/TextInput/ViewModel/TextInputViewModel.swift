//
//  TextInputViewModel.swift
//  Wallet
//

import UIKit

enum TextInputScreenType: String {
    case walletName, walletLimit, operationValue
}

protocol TextInputViewModelDelegate: AnyObject {
    func textInputViewModelCloseButtonDidTap()
    
    func textInputViewModelValueChanged(screen: TextInputScreenType, value: String?)
}

final class TextInputViewModel {
    var screen: TextInputScreenType
    var title: String
    var textInputPrompt: String
    var buttonTitle: String
    var isModal: Bool
    var keyboardType: UIKeyboardType
    
    var text: String?
    
    weak var delegate: TextInputViewModelDelegate?
    
    private init(
        screen: TextInputScreenType,
        title: String,
        textInputPrompt: String,
        buttonTitle: String,
        isModal: Bool,
        keyboardType: UIKeyboardType
    ) {
        self.screen = screen
        self.title = title
        self.textInputPrompt = textInputPrompt
        self.buttonTitle = buttonTitle
        self.isModal = isModal
        self.keyboardType = keyboardType
    }
    
    func closeButtonDidTap() {
        delegate?.textInputViewModelCloseButtonDidTap()
    }
    
    func onNewValue(_ value: String?) {
        delegate?.textInputViewModelValueChanged(screen: screen, value: value)
    }
}

extension TextInputViewModel {
    static func makeWalletName(isModal: Bool = false) -> TextInputViewModel {
        TextInputViewModel(
            screen: .walletName,
            title: R.string.localizable.wallet_name_title(),
            textInputPrompt: R.string.localizable.wallet_name_prompt(),
            buttonTitle: R.string.localizable.default_save_button(),
            isModal: isModal,
            keyboardType: .default
        )
    }
    
    static func makeWalletLimit(isModal: Bool = false) -> TextInputViewModel {
        TextInputViewModel(
            screen: .walletLimit,
            title: R.string.localizable.wallet_limit_title(),
            textInputPrompt: R.string.localizable.wallet_limit_prompt(),
            buttonTitle: R.string.localizable.default_save_button(),
            isModal: isModal,
            keyboardType: .numberPad
        )
    }
}
