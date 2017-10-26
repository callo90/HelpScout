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
        var deviceInfo = "\(self)\n\nApp Version: \(versionString)\nDevice Information:\n"
        deviceInfo.append("Device: \(UIDevice.current.modelIdentifier)\n")
        deviceInfo.append("\(UIDevice.current.systemName) Version: \(UIDevice.current.systemVersion)\n")
        let languageDescription = Locale.current.localizedString(forIdentifier: Locale.current.identifier) ?? "?"
        let languageCode = Locale.current.languageCode ?? "?"
        let regionCode = Locale.current.regionCode ?? "?"
        deviceInfo.append("Language: \(languageCode)-\(regionCode) (\(languageDescription))\n")
        deviceInfo.append("Timezone: \(TimeZone.current.abbreviation() ?? "?")\n")
        return deviceInfo
    }
    
}
