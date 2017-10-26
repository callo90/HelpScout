//
//  Result.swift
//  HelpScout
//
//  Created by Oscar De Moya on 10/26/17.
//  Copyright © 2017 Koombea. All rights reserved.
//

import Foundation

public enum Result<T> {
    
    case success(T)
    case failure(Error)
    
}
