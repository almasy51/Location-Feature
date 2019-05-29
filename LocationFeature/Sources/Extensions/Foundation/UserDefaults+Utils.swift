//
//  UserDefaults+Utils.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/28/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import Foundation

// MARK: - Methods

extension UserDefaults {
    
    /// Get object from UserDefaults by using subscript.
    public subscript(key: String) -> Any? {
        get {
            return object(forKey: key)
        }
        set {
            set(newValue, forKey: key)
        }
    }
    
    /// Retrieves a Codable object from UserDefaults.
    func object<T: Codable>(ofType type: T.Type,
                            forKey key: String,
                            usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
    
    /// Allows storing of Codable objects to UserDefaults.
    func set<T: Codable>(object: T,
                         forKey key: String,
                         usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
    
}
