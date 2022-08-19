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
    
    func showErrorPopup(type: ErrorPopupType) {
        DispatchQueue.main.async {
            self.popupView.show(type: type)
        }
    }
}
