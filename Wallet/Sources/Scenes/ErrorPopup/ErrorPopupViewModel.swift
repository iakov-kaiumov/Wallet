//
//  ErrorPopupViewModel.swift
//  Wallet
//

import Foundation
import UIKit

final class ErrorPopupViewModel {
    
    // MARK: - Properties
    private let parent: UIView
    private let popupView: PopupViewHolder
    
    init(parent: UIView) {
        self.parent = parent
        self.popupView = PopupViewHolder(parent: parent)
    }
    
    func showErrorPopup() {
        popupView.show(message: R.string.localizable.error_unknown_title())
    }
    
    func hideErrorPopup() {
        popupView.hide()
    }
}
