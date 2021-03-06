//
//  AppModel.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI

/// Information About this App
struct AppModel {
    
    let os: String = "ios"
    let appID: String
    let appShortVersion: String
    let appBuildVersin: String
    init() {
        self.appID = Bundle.main.bundleIdentifier ?? "~"
        self.appShortVersion =  (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "~"
        self.appBuildVersin = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "~"
    }
}
