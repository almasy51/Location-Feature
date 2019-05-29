//
//  MapLocationModel.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/22/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import Foundation
import MapKit

class MapLocationModel: NSObject, MKAnnotation, Codable {
    let id: String
    let title: String?
    let imageName: String?
    let coordinate: CLLocationCoordinate2D
    let landmark: LandMark?
    
    init(id: String, title: String?, imageName: String?, latitude: Double, longitude: Double, landmark: String) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.landmark = LandMark(rawValue: landmark) ?? .generic
        
        super.init()
    }
    
    init?(map: NSObject) {
        guard let id = map.value(forKey: "id") as? String,
            let latitude = map.value(forKey: "latitude") as? Double,
            let longitude = map.value(forKey: "longitude") as? Double else {
            return nil
        }
        
        self.id = id
        self.title = map.value(forKey: "title") as? String ?? ""
        self.imageName = map.value(forKey: "imageName") as? String ?? ""
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if let landmark = map.value(forKey: "landmark") as? String {
            self.landmark = LandMark(rawValue: landmark) ?? .generic
        } else {
            self.landmark = .generic
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageName
        case latitude
        case longitude
        case landmark
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        imageName = try values.decode(String.self, forKey: .imageName)
        let latitude = try values.decode(Double.self, forKey: .latitude)
        let longitude = try values.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        landmark = try values.decode(LandMark.self, forKey: .landmark)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(landmark, forKey: .landmark)
    }
}
