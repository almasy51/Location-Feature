//
//  LocationMarkerView.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/23/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import Foundation
import MapKit

class LocationMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let marker = newValue as? MapLocationModel else {
                return
            }
            canShowCallout = false
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            if let imageName = marker.imageName, let image = UIImage(named: imageName) {
                glyphImage = image
                markerTintColor = marker.landmark?.tintColor
            } else {
                glyphImage = UIImage(named: "Default")
                markerTintColor = LandMark.generic.tintColor
            }
        }
    }
}
