//
//  UIColor+Utils.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/28/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import UIKit

extension UIColor {
    /// Creates UIColor from hexadecimal value with optional transparency.
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
