//
//  DotView.swift
//  Wallet

import UIKit

class DotView: UIView {
    enum DotColor {
        case red
        case green
        
        func getColor() -> UIColor? {
            switch self {
            case .red:
                return R.color.redDot()
            case .green:
                return R.color.greenDot()
            }
        }
    }
    
    init(color: DotColor) {
        super.init(frame: CGRect(x: 0, y: 0, width: Constants.dotSize, height: Constants.dotSize))
        setup(color: color)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private methods
    private func setup(color: DotColor) {
        backgroundColor = color.getColor()
        layer.cornerRadius = Constants.dotSize / 2.0
        translatesAutoresizingMaskIntoConstraints = false
        self.snp.makeConstraints {
            $0.width.equalTo(Constants.dotSize)
            $0.height.equalTo(Constants.dotSize)
        }
    }
    
}

// MARK: - Constants
fileprivate extension Constants {
    static let dotSize: CGFloat = 8
}
