//
//  UIView+Utils.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/22/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import UIKit

extension UIView {
    
    /// The view's size.
    var size: CGSize {
        get { return frame.size }
        set {
            width = newValue.width
            height = newValue.height
        }
    }
    
    /// The view's width.
    var width: CGFloat {
        get { return frame.size.width }
        set { frame.size.width = newValue }
    }
    
    /// The view's height.
    var height: CGFloat {
        get { return frame.size.height }
        set { frame.size.height = newValue }
    }
    
    /// The view's x-coordinate.
    var x: CGFloat {
        get { return frame.origin.x }
        set { frame.origin.x = newValue }
    }
    
    /// The view's y-coordinate.
    var y: CGFloat {
        get { return frame.origin.y }
        set { frame.origin.y = newValue }
    }
    
    /// Adds shadow to the view.
    func addShadow(ofColor color: UIColor = .black, radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = true
    }
}
