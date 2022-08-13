//
//  DotView.swift
//  Wallet

import UIKit

enum DotSize: CGFloat {
    case size = 8
}

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
        super.init(frame: CGRect(x: 0, y: 0, width: DotSize.size.rawValue, height: DotSize.size.rawValue))
        setup(color: color)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private methods
    private func setup(color: DotColor) {
        backgroundColor = color.getColor()
        layer.cornerRadius = DotSize.size.rawValue / 2.0
        translatesAutoresizingMaskIntoConstraints = false
        self.snp.makeConstraints {
            $0.width.equalTo(DotSize.size.rawValue)
            $0.height.equalTo(DotSize.size.rawValue)
        }
    }
    
}
