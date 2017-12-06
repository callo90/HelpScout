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
    
    public static func createConversation(user: HelpScoutUser, body: String, attachment: HelpScoutAttachment? = nil, completion: @escaping (Result<Any?>) -> ()) {
        ConversationStore.create(user, body: body, attachment: attachment, completion: completion)
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
    
    static func create(_ user: HelpScoutUser, body: String, attachment: HelpScoutAttachment? = nil, completion: @escaping (Result<Any?>) -> ()) {
        if let attachment = attachment {
            createAttachment(attachment) { attachment in
                self.createConversation(user, body: body, attachment: attachment, completion: completion)
            }
            return
        }
        createConversation(user, body: body, completion: completion)
    }
    
    private static func createConversation(_ user: HelpScoutUser, body: String, attachment: [String: Any]? = nil, completion: @escaping (Result<Any?>) -> ()) {
        
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
        var body = "User: \(user.id)\n"
        body += body.appendingMetaData
        
        var thread: [String : Any] = [
            "type": "customer",
            "createdBy": [
                "type": "customer",
                "email": "\(user.email)",
                "firstName": "\(user.firstName)",
                "lastName": "\(user.lastName)"
            ],
            "body": "\(body)",
            "status": "active",
            "createdAt": "\(createdAt)",
        ]
        if let attachment = attachment { thread["attachments"] =  [attachment] }
        let parameters: [String : Any] = [
            "type": "email",
            "customer": [
                "email": "\(user.email)",
                "firstName": "\(user.firstName)",
                "lastName": "\(user.lastName)"
            ],
            "subject": "Support request from \(user.firstName) \(user.lastName)",
            "mailbox": [
                "id": "\(config.mailboxID)"
            ],
            "status": "active",
            "createdAt": "\(createdAt)",
            "threads": [thread]
        ]
        API.request("https://api.helpscout.net/v1/conversations.json",
                    method: .post, parameters: parameters, completion: completion)
    }
    
    private static func createAttachment(_ attachment: HelpScoutAttachment, completion: @escaping ([String: Any]?) -> ()) {
        API.request("https://api.helpscout.net/v1/attachments.json", method: .post, parameters: attachment.toJSON()) { result in
            switch result {
            case .success(let value):
                guard let value = value as? [String: Any], let item = value["item"] as? [String: Any] else { return }
                completion(item)
            case .failure:
                completion(nil)
                break
            }
        }
    }
    
}
