//
//  HelpScout.swift
//  HelpScout
//
//  Created by Oscar De Moya on 10/26/17.
//  Copyright © 2017 Koombea. All rights reserved.
//

import UIKit
import Alamofire

public struct HelpScout {
    
    var mailboxID: Int
    var token: String
    
    static var config: HelpScout?
    
    public static func configure(mailboxID: Int, token: String) {
        HelpScout.config = HelpScout(mailboxID: mailboxID, token: token)
    }
    
    public static func createConversation(
        email: String, firstName: String, lastName: String, body: String, completion: @escaping (Result<Any?>) -> ()) {
        ConversationStore.create(email: email,
                                 firstName: firstName,
                                 lastName: lastName,
                                 body: body,
                                 completion: completion)
    }
    
}

enum HelpScoutError: Error {
    
    case notConfigured
    
    var localizedDescription: String {
        switch self {
        case .notConfigured:
            return """
            ERROR: Help Scout not configured.
            Please use 'HelpScout.configure(mailboxID: Int, token: String)' before making this call.
            """
        }
    }
    
}

struct ConversationStore {
    
    static func create(email: String, firstName: String, lastName: String, body: String,
                       completion: @escaping (Result<Any?>) -> ()) {
        guard let config = HelpScout.config else {
            let error = HelpScoutError.notConfigured
            print(error.localizedDescription)
            completion(Result.failure(error))
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let createdAt = formatter.string(from: Date())
        let parameters: [String : Any] = [
            "type": "email",
            "customer": [
                "email": "\(email)",
                "firstName": "\(firstName)",
                "lastName": "\(lastName)"
            ],
            "subject": "Support request from \(firstName) \(lastName)",
            "mailbox": [
                "id": "\(config.mailboxID)"
            ],
            "status": "active",
            "createdAt": "\(createdAt)",
            "threads": [
                [
                    "type": "customer",
                    "createdBy": [
                        "type": "customer",
                        "email": "\(email)",
                        "firstName": "\(firstName)",
                        "lastName": "\(lastName)"
                    ],
                    "body": "\(body.appendingMetaData)",
                    "status": "active",
                    "createdAt": "\(createdAt)"
                ]
            ]
        ]
        API.request("https://api.helpscout.net/v1/conversations.json",
                    method: .post, parameters: parameters, completion: completion)
    }
    
}
