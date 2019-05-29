//
//  GeofencingHelper.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/28/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import Foundation
import CoreLocation

final class GeofencingHelper {
    
    enum GeofencingHelperError: Error {
        case errorSortingGeofences
        case errorCreatingGeofenceRegions
    }
    
    // MARK: Private Properties
    
    private let locationManager = CLLocationManager()
    
    // MARK: Initialization
    
    init() {
        loadGeofenceLocations()
    }
    
    // MARK: API: Get Geofences
    
    func loadGeofenceLocations() {
        /// NOTE: Do any API requests here ideally using Promises or Reactive development to
        /// get, arrange, and monitor the data
        guard CLLocationManager.authorizationStatus() == .authorizedAlways else { return }
        
        if let locations = loadMockGeofenceLocations(),
            let sortedLocations = sortGeofenceLocations(from: locations),
            let geofenceRegions = createGeofenceRegions(from: sortedLocations) {
            UserDefaults.geofenceLocations = locations
            startMonitoringRegions(geofenceRegions)
        }
    }
    
    // MARK: Start / Stop Monitoring Regions
    
    func startMonitoringRegions(_ regions: [CLCircularRegion]) {
        regions.forEach { locationManager.startMonitoring(for: $0) }
    }
    
    func stopMonitoringRegions() {
        locationManager.monitoredRegions.forEach { locationManager.stopMonitoring(for: $0) }
    }
    
}

// MARK: - Private Methods

private extension GeofencingHelper {
    
    // MARK: Sort Geofence Locations
    
    func sortGeofenceLocations(from geoLocations: [MapLocationModel]?) -> [MapLocationModel]? {
        guard let locations = geoLocations,
            let userLocation = locationManager.location else {
                return nil
        }
        
        let sortedLocations = locations.sorted(by: { (geofence1: MapLocationModel, geofence2: MapLocationModel) -> Bool in
            
            let geofence1Location = CLLocation(latitude: geofence1.coordinate.latitude, longitude: geofence1.coordinate.longitude)
            let distanceToGeofence1 = userLocation.distance(from: geofence1Location)
            
            let geofence2Location = CLLocation(latitude: geofence2.coordinate.latitude, longitude: geofence2.coordinate.longitude)
            let distanceToGeofence2 = userLocation.distance(from: geofence2Location)
            
            return (distanceToGeofence1 < distanceToGeofence2)
        })
        
        return sortedLocations
    }
    
    // MARK: Create Geofence Regions
    
    func createGeofenceRegions(from locations: [MapLocationModel]) -> [CLCircularRegion]? {
        var regions = [CLCircularRegion]()
        for location in locations {
            if let region = createRegion(for: location) {
                regions.append(region)
            }
        }
        return regions
    }
    
    func createRegion(for location: MapLocationModel) -> CLCircularRegion? {
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude)
        let region = CLCircularRegion(center: center, radius: 200, identifier: location.id)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        return region
    }
    
}

// MARK: - Mock Geofence Locations

private extension GeofencingHelper {
    
    func loadMockGeofenceLocations() -> [MapLocationModel]? {
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
}
