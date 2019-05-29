//
//  Data+Utils.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/28/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import Foundation

extension Data {
    
    /// Converts the device token data to a string.
    func deviceTokenString() -> String {
        return reduce("", {$0 + String(format: "%02X", $1)})
    }
    
}
