//
//  Defaults.swift
//  Live It
//
//  Created by Muniyaraj on 20/08/24.
//

import Foundation

public extension UserDefaults{
    func setObject<T>(value: T,key: Defaults){
        switch value{
        case let intValue as Int:
            set(intValue, forKey: key.rawValue)
        case let boolValue as Bool:
            set(boolValue, forKey: key.rawValue)
        case let doubleValue as Double:
            set(doubleValue, forKey: key.rawValue)
        case let stringValue as String:
            set(stringValue, forKey: key.rawValue)
        default:
            set(value, forKey: key.rawValue)
        }
    }
    func getObject<T>(key: Defaults)-> T?{
        return object(forKey: key.rawValue) as? T
    }
    enum Defaults: String{
        case loggedIn
        case token
        case languageCode
    }
    func clearUserDefaults(){
        let defaults = UserDefaults.standard
        if let bundleId = Bundle.main.bundleIdentifier{
            defaults.removePersistentDomain(forName: bundleId)
        }
        defaults.synchronize()
    }
}
