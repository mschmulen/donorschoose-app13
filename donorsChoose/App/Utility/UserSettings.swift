//
//  UserSettings.swift
//  donorsChoose
//
//

import Foundation
import Combine

/// UserSettings
final class UserSettings: ObservableObject {
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("ShowOnboarding", defaultValue: true)
    var showOnboarding: Bool {
        willSet {
            objectWillChange.send()
        }
    }
}

@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
}

/**
 
 Usage:
 struct ContentView: View {
 @ObservedObject var settings = UserSettings()
 var body: some View {
     VStack {
         Toggle(isOn: $settings.showOnboarding) {
             Text("Show Onboarding")
         }
         if settings.showOnboarding{
             Text("Hello")
         }
     }
 }
 */
