//
//  OrientationLock.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/31/26.
//

import UIKit
import SwiftUI

enum OrientationLock {
    static var mask: UIInterfaceOrientationMask = .all
}

struct OrientationLocKModiifer: ViewModifier {
    let orientation: UIInterfaceOrientationMask
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                OrientationLock.mask = orientation
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: OrientationLock.mask))
            }
            .onDisappear {
                OrientationLock.mask = .all
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: OrientationLock.mask))
            }
    }
}
