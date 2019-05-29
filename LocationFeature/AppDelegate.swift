//
//  AppDelegate.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/22/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let locationManager = CLLocationManager()
    private let geofencingHelper = GeofencingHelper()
    private let notificationsManager = NotificationsManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager.delegate = self
        if let _ = locationManager.delegate {
            locationManager.requestAlwaysAuthorization()
        }
        geofencingHelper.loadGeofenceLocations()
        return true
    }
}

// MARK: - Notifications Handling

extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        notificationsManager.successfullyRegisteredForNotifications(deviceToken: deviceToken)
    }
}

// MARK: - CLLocationManager Delegate Methods

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        if let geofenceModel = UserDefaults.geofenceLocations?.first(where: { $0.id == region.identifier }) {
            self.sendLocalNotification(message: "Arrived at \(geofenceModel.title ?? "Location")")
        }
    }
    
}

// MARK: - Local Notifications

private extension AppDelegate {
    
    func sendLocalNotification(message: String, completion: ((_ success: Bool) -> Void)? = nil) {
        let content = UNMutableNotificationContent()
        content.title = ""
        content.subtitle = ""
        content.body = message
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "\(UIApplication.bundleIdentifier)_localNotification",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let _ = error {
                completion?(false)
            } else {
                completion?(true)
            }
        }
    }
    
}

