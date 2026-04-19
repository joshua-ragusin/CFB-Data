//
//  SFSymbol.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

enum SFSymbol: String {
    case exclamationMarkTriangleFill = "exclamationmark.triangle.fill"
    case listBulletinFill = "list.bullet"
    case americanFootball = "american.football"
    case arrowShapeRightFill = "arrowshape.right.fill"
    case chevronUp = "chevron.up"
    case chevronDown = "chevron.down"
    case chevronRight = "chevron.right"
    case chevronLeft = "chevron.left"
    case checkmark = "checkmark"
    case plusCircle = "plus.circle"
    case xMarkCircleFill = "xmark.circle.fill"
    case at = "at"
    
    var value: String {
        rawValue
    }
}
