//
//  Date+Extensions.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 28.07.2025.
//

import Foundation

extension Date {
    func toString(format: String = "dd/MM/yy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
}
