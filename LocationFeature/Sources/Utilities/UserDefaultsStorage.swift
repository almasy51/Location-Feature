//
//  UserDefaultsStorage.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/28/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import Foundation
import UIKit

extension UserDefaults {
    
    /// Holds the UserDefaults constants.
    struct Constants {
        @available(*, unavailable, message: "Do not instantiate UserDefaults") init() {}
        
        static let geofenceLocations        = "\(UIApplication.bundleIdentifier)_geofenceLocations"
    }
    
    class var geofenceLocations: [MapLocationModel]? {
        get { return standard.object(ofType: [MapLocationModel].self, forKey: Constants.geofenceLocations) }
        set { standard.set(object: newValue, forKey: Constants.geofenceLocations) }
    }
}
