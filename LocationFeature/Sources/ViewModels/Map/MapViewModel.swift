//
//  MapViewModel.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/22/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import MapKit

protocol MapLocationsViewModelType: class {
    var locations: [MapLocationModel]? { get }
    
    func loadLocations()
    func getLocation(index: Int) -> MapLocationModel?
    func sortLocations(location: CLLocation?)
}

final class MapLocationsViewModel: MapLocationsViewModelType {
    
    // MARK: Public Properties
    
    var locations: [MapLocationModel]? {
        if let list = locationList {
            return Array(list.prefix(5))
        }
        return nil
    }
    
    // MARK: Private Properties
    
    private var locationList: [MapLocationModel]?
    private let locationManager: CLLocationManager
    
    // MARK: Initialization
    
    init(
        locationManager: CLLocationManager = CLLocationManager()
        ) {
        self.locationManager = locationManager
    }
    
    // MARK: Get Locations
    
    func loadLocations() {
        self.locationList = parsePlist() ?? []
        sortLocations(location: nil)
    }
    
    func parsePlist() -> [MapLocationModel]? {
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Locations", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
            if let locations = nsDictionary?.mutableArrayValue(forKey: "locations") as? [NSObject] {
                var allLocations = [MapLocationModel]()
                for location in locations {
                    if let parsedLocation = MapLocationModel(map: location) {
                        allLocations.append(parsedLocation)
                    }
                }
                return allLocations
            }
        }
        return nil
    }
    
    func getLocation(index: Int) -> MapLocationModel? {
        return locationList?[optional: index]
    }
    
    func sortLocations(location: CLLocation?) {
        guard let locationList = self.locationList,
            var userLocation = locationManager.location else {
                return
        }
        
        userLocation = location ?? userLocation
        
        let sortedLocations = locationList.sorted(by: { (location1: MapLocationModel, location2: MapLocationModel) -> Bool in
            
            let map1Location = CLLocation(latitude: location1.coordinate.latitude, longitude: location1.coordinate.longitude)
            let distanceToLocation1 = userLocation.distance(from: map1Location)
            
            let map2Location = CLLocation(latitude: location2.coordinate.latitude, longitude: location2.coordinate.longitude)
            let distanceToLocation2 = userLocation.distance(from: map2Location)
            
            return (distanceToLocation1 < distanceToLocation2)
        })
        
        self.locationList = sortedLocations
    }
    
}
