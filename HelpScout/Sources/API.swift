//
//  API.swift
//  HelpScout
//
//  Created by Oscar De Moya on 10/26/17.
//  Copyright © 2017 Koombea. All rights reserved.
//

import Alamofire

struct API {
    
    static func request(_ url: URLConvertible, method: Alamofire.HTTPMethod = .get, parameters: Parameters? = nil,
                        completion: @escaping (Result<Any?>) -> ()) {
        guard let config = HelpScout.config else {
            let error = HelpScoutError.notConfigured
            print(error.localizedDescription)
            completion(Result.failure(error))
            return
        }
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default)
            .authenticate(user: config.token, password: "x")
            .responseJSON { response in
                if let error = response.error {
                    if let statusCode = response.response?.statusCode, (200..<300) ~= statusCode,
                        let error = error as? AFError, error.isEmptyResponse {
                        print(error)
                        completion(Result.success(nil))
                    } else {
                        print(error)
                        completion(Result.failure(error))
                    }
                } else if let result = response.result.value {
                    print(result)
                    completion(Result.success(result))
                }
        }
    }
    
}

extension AFError {
    
    var isEmptyResponse: Bool {
        guard case .responseSerializationFailed(let reason) = self else { return false }
        return reason.isEmptyResponse
    }
    
}

extension AFError.ResponseSerializationFailureReason {
    
    var isEmptyResponse: Bool {
        switch self {
        case .inputDataNil, .inputDataNilOrZeroLength:
            return true
        default:
            return false
        }
    }
    
}
