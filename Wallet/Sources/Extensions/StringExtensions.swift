//
//  StringExtensions.swift
//  Wallet
//

import Foundation

extension String {
    var encodeUrl: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? self
    }
    
    var decodeUrl: String {
        return self.removingPercentEncoding ?? self
    }
    
    var toDecimal: Decimal? {
        Decimal(string: self.filter("0123456789.".contains))
    }
}
