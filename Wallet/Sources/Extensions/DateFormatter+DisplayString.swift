//
//  TimeFormatter+DisplayString.swift
//  Wallet
//

import Foundation

fileprivate extension Constants {
    static let hoursMinutes = "H:mm"
    static let dayMonth = "d MMMM"
}

extension DateFormatter {
    static let hoursMinutes = makeDateFormatter(format: Constants.hoursMinutes)
    static let dayMonth = makeDateFormatter(format: Constants.dayMonth)
    
    private static func makeDateFormatter(format: String,
                                          timeZone: TimeZone = .current) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = .current
        formatter.dateFormat = format
        return formatter
    }
}
