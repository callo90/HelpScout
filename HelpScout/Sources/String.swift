//
//  String.swift
//  HelpScout
//
//  Created by Oscar De Moya on 10/26/17.
//  Copyright © 2017 Koombea. All rights reserved.
//

import UIKit

extension String {
    
    var versionString: String {
        let versionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
        let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!
        return "\(versionString) (\(bundleVersion))"
    }
    
    var appendingMetaData: String {
        let languageCode = Locale.current.languageCode ?? "?"
        let regionCode = Locale.current.regionCode ?? "?"
        let languageDescription = Locale.current.localizedString(forIdentifier: Locale.current.identifier) ?? "?"
        
        var deviceInfo = "App Version: " + versionString + "\n"
        deviceInfo += "Device: \(UIDevice().modelName)\n"
        deviceInfo += "iOS: \(UIDevice.current.systemVersion)\n"
        deviceInfo += "Language: \(languageCode)-\(regionCode) (\(languageDescription))\n"
        deviceInfo += "Timezone: \(TimeZone.current.abbreviation() ?? "?")\n"
        return deviceInfo
    }
    
}
