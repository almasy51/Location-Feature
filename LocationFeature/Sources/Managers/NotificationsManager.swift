//
//  NotificationsManager.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/28/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

final class NotificationsManager: NSObject {
    
    // MARK: Singleton
    
    static let shared = NotificationsManager()
    
    // MARK: Public Properties
    
    private(set) var deviceToken: String?
    
    // MARK: Initialization
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
}

// MARK: - Registering and Handling

extension NotificationsManager {
    
    func successfullyRegisteredForNotifications(deviceToken: Data) {
        self.deviceToken = deviceToken.deviceTokenString()
    }
    
}

// MARK: - Permissions Handling

extension NotificationsManager {
    
    func hasUserBeenAskedAboutPushNotifications(hasBeenAsked: @escaping (Bool) -> Void) {
        getAuthStatus() { status in
            DispatchQueue.main.async {
                switch status {
                case .notDetermined: // Not asked yet
                    hasBeenAsked(false)
                case .denied,        // Asked and denied
                .authorized,
                .provisional:    // Asked and accepted
                    hasBeenAsked(true)
                @unknown default:
                    break
                }
            }
        }
    }
    
    func requestNotificationsPermissions(completion: ((_ permissionsGranted: Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                DispatchQueue.main.async {
                    if granted {
                        UIApplication.shared.registerForRemoteNotifications()
                        completion?(true)
                    } else {
                        completion?(false)
                    }
                }
        }
    }
    
    func arePermissionsGranted(permissionsGranted: @escaping (Bool) -> Void) {
        getAuthStatus() { status in
            DispatchQueue.main.async {
                switch status {
                case .notDetermined,
                     .denied:
                    permissionsGranted(false)
                case .authorized,
                     .provisional:
                    permissionsGranted(true)
                @unknown default:
                    break
                }
            }
        }
    }
    
}

// MARK: - UNUserNotificationCenter Delegate Methods

extension NotificationsManager: UNUserNotificationCenterDelegate {
    
    // This gets called when a notification comes in while you're in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Modify the notification as you wish, then call the completion handler.
        completionHandler(.alert)
    }
    
    // Called when the user selects an action or dismisses a notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
}

// MARK: - Local Notifications

extension NotificationsManager {
    
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

// MARK: - Private Methods

private extension NotificationsManager {
    
    func getAuthStatus(status: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter
            .current()
            .getNotificationSettings {
                settings in
                status(settings.authorizationStatus)
        }
    }
    
}
