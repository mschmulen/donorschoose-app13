//
//  UserSettings.swift
//  donorsChoose
//
//  Created by Matthew Schmulen on 7/22/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import Combine


/**
 
 Usage:
 struct ContentView: View {
 @ObservedObject var settings = UserSettings()
 var body: some View {
     VStack {
         Toggle(isOn: $settings.showOnStart) {
             Text("Show welcome text")
         }
         if settings.showOnStart{
             Text("Welcome")
         }
     }
 }
 */
final class UserSettings: ObservableObject {

    let objectWillChange = PassthroughSubject<Void, Never>()

    @UserDefault("ShowOnStart", defaultValue: true)
    var showOnStart: Bool {
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
