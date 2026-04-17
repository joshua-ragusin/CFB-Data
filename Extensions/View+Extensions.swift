//
//  View+Extensions.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/31/26.
//

import SwiftUI

extension View {
    func lockOrientation(_ orientation: UIInterfaceOrientationMask) -> some View {
        modifier(OrientationLocKModiifer(orientation: orientation))
    }
}
