//
//  PopupViewHolder.swift
//  Wallet
//

import UIKit

final class PopupViewHolder {
    
    // MARK: - Properties
    private let parent: UIView
    
    private lazy var popupView: PopupView = PopupView()
    private var initialViewCenter: CGPoint = CGPoint()
    private let hidingThreshold: CGFloat = 20
    private var isShown: Bool = false
    
    init(parent: UIView) {
        self.parent = parent
    }
    
    // MARK: Public methods
    func show(type: ErrorPopupType) {
        guard !isShown else {
            return
        }
        isShown = true
        let message = type.title()
        let image = type.icon()
        parent.addSubview(popupView)
        
        popupView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(parent.safeAreaLayoutGuide.snp.top).inset(0)
            $0.height.equalTo(56)
        }
        popupView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureAction)))
        
        popupView.configure(message: message, image: image)
        
        popupView.center.y = -200
        UIView.animate(
            withDuration: 0.33,
            delay: 0.0,
            animations: { [weak self] in
                self?.popupView.center.y = 0
            },
            completion: nil
        )
//        popupView.alpha = 0.0
//        UIView.animate(
//            withDuration: 0.33,
//            delay: 0.0,
//            animations: { [weak self] in
//                self?.popupView.alpha = 1.0
//            },
//            completion: nil
//        )
    }
    
    func hide() {
        hide(popupView)
    }
    
    // MARK: - Actions
    @objc private func panGestureAction(_ gesture: UIPanGestureRecognizer) {
        guard let errorView = gesture.view else { return }
        let point = gesture.translation(in: parent)
        
        if gesture.state == .began {
            initialViewCenter = errorView.center
        }
        if gesture.state != .cancelled {
            let alpha = max(0, 0.5 - abs(errorView.center.y - initialViewCenter.y) / parent.bounds.height * 4)
            errorView.center = CGPoint(x: errorView.center.x, y: errorView.center.y + point.y * alpha)
            gesture.setTranslation(CGPoint.zero, in: parent)
        }
        
        if gesture.state == .cancelled || gesture.state == .ended {
            if (initialViewCenter.y - errorView.center.y) > hidingThreshold {
                hide(errorView)
            } else {
                reset(errorView)
            }
        }
    }
    
    // MARK: Private methods
    private func hide(_ errorView: UIView) {
        UIView.animate(
            withDuration: 0.7,
            delay: 0.0,
            options: [.curveEaseInOut],
            animations: {
                errorView.center.y = -200
            },
            completion: { _ in
//                errorView.removeFromSuperview()
                self.isShown = false
            }
        )
    }
    
    private func reset(_ errorView: UIView) {
        UIView.animate(
            withDuration: 0.33,
            delay: 0.0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                guard let self = self else { return }
                errorView.center = self.initialViewCenter
            },
            completion: nil
        )
    }
}
