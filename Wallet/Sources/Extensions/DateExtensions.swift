//
//  DateExtensions.swift
//  Wallet
//

import Foundation

extension Date {
    func daysBetween(date: Date) -> Int {
        let date1 = Calendar.current.startOfDay(for: self)
        let date2 = Calendar.current.startOfDay(for: date)
        if let daysBetween = Calendar.current.dateComponents([.day], from: date1, to: date2).day {
            return daysBetween
        }
        return 0
    }
}
