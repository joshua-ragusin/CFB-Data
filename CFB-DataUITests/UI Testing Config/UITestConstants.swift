//
//  UITestConstants.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/17/26.
//

import Foundation

enum UITestConstants {
    // 4. Merged delay and timeout — both represented the same concept
    enum timeout: TimeInterval {
        case veryShort = 1.0
        case short = 2.5
        case standard = 5.0
        case long = 10.0
    }
}
