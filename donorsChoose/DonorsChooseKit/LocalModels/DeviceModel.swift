//
//  DeviceModel.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI

struct DeviceModel {
    
    let idfv: UUID?
    let localeLanguageCode: String?
    let localeRegionCode: String?
    let localePreferredLanguages: [String]
    let isSimulator: Bool
    
    init() {
        
        self.idfv = UIDevice.current.identifierForVendor
        let locale = Locale.current
        self.localeLanguageCode = locale.languageCode
        self.localeRegionCode = locale.regionCode
        self.localePreferredLanguages = Locale.preferredLanguages

        #if targetEnvironment(simulator)
            self.isSimulator = true
        #else
            self.isSimulator = false
        #endif
    }
    
}
