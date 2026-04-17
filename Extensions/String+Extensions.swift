//
//  String+Extensions.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/16/26.
//

import Foundation

extension String {
    
    /// Converts a given string to a date given a format and locale
    /// - Parameters:
    ///   - format: The format of the date string
    ///   - locale: The locale the date string should be converted to
    func convertToDate(format: String, locale: Locale=Locale(identifier: "en_US_POSIX")) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = locale
        return dateFormatter.date(from: self)
    }
    
    
    /// Returns the initials of the string.
    /// e.g "John F Kennedy" -> "JFK"
    func initialized() -> String {
        let words = self.split(separator: " ")
        return words.map { $0.prefix(1) }.joined()
    }
}
