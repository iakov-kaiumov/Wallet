//
//  DotColor.swift
//  Wallet
//

import UIKit

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
