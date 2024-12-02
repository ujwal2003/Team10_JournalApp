//
//  UserDefaultsHelper.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 12/2/24.
//

import Foundation

class UserDefaultsHelper {
    static let localStorage = UserDefaultsHelper()
    private let defaults = UserDefaults.standard
    
    private init() { }
    
    /// Saves ``Codable`` value into local user defaults database
    func save<T: Codable>(_ value: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            defaults.set(encoded, forKey: key)
        }
    }
    
    /// Returns saved ``Codable`` data from local user defaults database
    func fetch<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        if let data = defaults.data(forKey: key), let decoded = try? JSONDecoder().decode(type, from: data) {
            return decoded
        }
        
        return nil
    }
    
    /// Saves value of simple data type into local user defaults database
    func save(_ value: Any, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    /// Returns saved simple value from local user defaults database
    func fetch(forKey key: String) -> Any? {
        return defaults.value(forKey: key)
    }
    
    /// Deletes value from local user defaults database
    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}
