//
//  HelpScoutAttachment.swift
//  HelpScout-iOS
//
//  Created by koombea on 12/4/17.
//  Copyright © 2017 Koombea. All rights reserved.
//

import Foundation

public struct HelpScoutAttachment {
    
    public var fileName: String
    public var mimeType: String
    public var data: Data
    
    public init(_ fileName: String, mimeType: String, data: Data) {
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
    }
    
    public func toJSON() -> [String: Any] {
        return ["fileName": fileName, "mimeType": mimeType, "data": self.data.base64EncodedString()]
    }
}
