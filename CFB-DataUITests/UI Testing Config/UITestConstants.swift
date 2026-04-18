//
//  UITestConstants.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/17/26.
//

import Foundation

enum UITestConstants {
    enum delay: TimeInterval {
        case veryShort = 1.0
        case short = 2.5
        case standard = 5.0
        case long = 10.0
    }
    
    enum timeout: TimeInterval {
        case short = 2.5
        case standard = 5.0
        case long = 10.0
    }
}
