//
//  User.swift
//  HelpScout-iOS
//
//  Created by koombea on 12/5/17.
//  Copyright © 2017 Koombea. All rights reserved.
//

import Foundation

public struct HelpScoutUser {

    public var id: String
    public var firstName: String
    public var lastName: String
    public var email: String
    
    public init(_ id: String, firstName: String, lastName: String, email: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
