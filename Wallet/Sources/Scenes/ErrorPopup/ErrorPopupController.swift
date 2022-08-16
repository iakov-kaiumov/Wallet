//
//  ErrorViewController.swift
//  Wallet
//

import Foundation
import UIKit

final class ErrorPopupController {
    
    // MARK: - Properties
    private var errorViewCenter: CGPoint = CGPoint()
    private let errorViewHidingThreshold: CGFloat = 20
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Actions
    @objc private func panGestureAction(_ gesture: UIPanGestureRecognizer) {
        guard let errorView = gesture.view else { return }
        let point = gesture.translation(in: window)
        
        if gesture.state == .began {
            errorViewCenter = errorView.center
        }
        if gesture.state != .cancelled {
            let alpha = max(0, 0.5 - abs(errorView.center.y - errorViewCenter.y) / window.bounds.height * 4)
            errorView.center = CGPoint(x: errorView.center.x, y: errorView.center.y + point.y * alpha)
            gesture.setTranslation(CGPoint.zero, in: window)
        }
        
        if gesture.state == .cancelled || gesture.state == .ended {
            if (errorViewCenter.y - errorView.center.y) > errorViewHidingThreshold {
                hide(errorView)
            } else {
                reset(errorView)
            }
        }
    }
    
    // MARK: Public methods
    func show() {
        let errorPopup = ErrorPopup(message: "Что-то пошло не так")
        window.addSubview(errorPopup)
        errorPopup.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(window.safeAreaLayoutGuide.snp.top).inset(0)
            $0.height.equalTo(56)
        }
        errorPopup.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureAction)))
    }
    
    func hide(_ errorView: UIView) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: [.curveLinear],
            animations: {
                errorView.center.y -= 200
            },
            completion: { _ in
                errorView.removeFromSuperview()
            }
        )
    }
    
    func reset(_ errorView: UIView) {
        UIView.animate(
            withDuration: 0.33,
            delay: 0.0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                guard let self = self else { return }
                errorView.center = self.errorViewCenter
            },
            completion: nil
        )
    }
    
}
