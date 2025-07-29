//
//  String+Extensions.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 28.07.2025.
//

import Foundation
import UIKit

extension String {
    func toDate(format: String = "MM/dd/yy") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        
        if let parsedDate = dateFormatter.date(from: self) {
            return parsedDate
        } else {
            let currentDateString = dateFormatter.string(from: Date())
            return dateFormatter.date(from: currentDateString) ?? Date()
        }
    }
    
    func createShortTitle() -> String {
        let words = self.split(separator: " ")
        guard words.count > 3 else {
            return self
        }
        let threeWords = words.prefix(4).joined(separator: " ")
        if threeWords.count > 12 {
            return words.prefix(3).joined(separator: " ")
        }
        return threeWords
    }
}
