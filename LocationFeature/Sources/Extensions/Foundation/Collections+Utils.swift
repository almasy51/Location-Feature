//
//  Collections+Utils.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/23/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import Foundation

extension Collection {
    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }
}
