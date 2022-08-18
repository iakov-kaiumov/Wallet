//
//  ErrorPopupType.swift
//  Wallet
//

import UIKit

enum ErrorPopupType {
    case unknownError
    case noInternet
    
    func icon() -> UIImage? {
        switch self {
        case .unknownError:
            return R.image.alertImage()
        case .noInternet:
            return R.image.noInternet()
        }
    }
    
    func title() -> String {
        switch self {
        case .unknownError:
            return R.string.localizable.error_unknown_title()
        case .noInternet:
            return R.string.localizable.error_connection_title()
        }
    }
}
