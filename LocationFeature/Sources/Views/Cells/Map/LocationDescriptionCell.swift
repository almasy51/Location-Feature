//
//  LocationDescriptionCell.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/23/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import UIKit

final class LocationDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var locationImageview: UIImageView!
    @IBOutlet weak var locationName: UILabel! {
        didSet {
            locationName.textColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1)
        }
    }
    
    // MARK: Setup
    
    func setup(location: MapLocationModel?) {
        locationName.text = location?.title
        
        
        if let landmark = location?.landmark, landmark != LandMark.generic {
            if let image = UIImage(named: landmark.description + "-detail") {
                locationImageview.image = image
            }
            if let image = UIImage(named: landmark.description) {
                locationImageview.image = image
            }
        } else {
            locationImageview.image = UIImage(named: "Default-detail")
            if let image = UIImage(named: "Default-tintable") {
                locationImageview.image = image
                locationImageview.image = image.withRenderingMode(.alwaysTemplate)
                locationImageview.tintColor = UIColor.white
            }
        }
    }
    
}
