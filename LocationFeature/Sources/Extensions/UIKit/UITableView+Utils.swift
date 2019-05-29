//
//  UITableView+Utils.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/23/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import UIKit

extension UITableView {
    /// Dequeues a reusable `UITableViewCell` using its class name for an indexPath.
    public func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as! T
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if point.y < 0 {
            return nil
        }
        return hitView
    }
}
