//
//  TextInputViewModel.swift
//  Wallet
//

import UIKit

enum TextInputScreenType: String {
    case walletName, walletNameIntermediate, walletLimit, operationAmount, categoryName
}

protocol TextInputViewModelDelegate: AnyObject {
    func textInputViewModelCloseButtonDidTap()
    
    func textInputViewModelValueChanged(screen: TextInputScreenType, value: String?)
}

enum ValidateOptions {
    case notEmpty
}

final class TextInputViewModel {
    var screen: TextInputScreenType
    var title: String
    var textInputPrompt: String
    var buttonTitle: String
    var isModal: Bool
    var keyboardType: UIKeyboardType
    var validateOptions: [ValidateOptions]
    
    var text: String?
    
    weak var delegate: TextInputViewModelDelegate?
    
    private init(
        screen: TextInputScreenType,
        title: String,
        textInputPrompt: String,
        buttonTitle: String,
        isModal: Bool,
        keyboardType: UIKeyboardType,
        validateOptions: [ValidateOptions] = []
    ) {
        self.screen = screen
        self.title = title
        self.textInputPrompt = textInputPrompt
        self.buttonTitle = buttonTitle
        self.isModal = isModal
        self.keyboardType = keyboardType
        self.validateOptions = validateOptions
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
            screen: isModal ? .walletName : .walletNameIntermediate,
            title: R.string.localizable.wallet_name_title(),
            textInputPrompt: R.string.localizable.wallet_name_prompt(),
            buttonTitle: isModal ? R.string.localizable.default_save_button() : R.string.localizable.default_next_button(),
            isModal: isModal,
            keyboardType: .default,
            validateOptions: [.notEmpty]
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
    
    static func makeOperationAmount(isModal: Bool = false) -> TextInputViewModel {
        TextInputViewModel(
            screen: .operationAmount,
            title: R.string.localizable.operation_amount_title(),
            textInputPrompt: R.string.localizable.operation_amount_prompt(),
            buttonTitle: R.string.localizable.default_next_button(),
            isModal: isModal,
            keyboardType: .numberPad
        )
    }
    
    static func makeCategoryName(isModal: Bool = false) -> TextInputViewModel {
        TextInputViewModel(
            screen: .categoryName,
            title: R.string.localizable.newcategory_enter_name(),
            textInputPrompt: R.string.localizable.newcategory_enter_name(),
            buttonTitle: isModal ? R.string.localizable.default_save_button() : R.string.localizable.default_next_button(),
            isModal: isModal,
            keyboardType: .default,
            validateOptions: [.notEmpty]
        )
    }
}
