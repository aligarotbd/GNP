//
//  RequestManager.swift
//  GlobalNewsPortal
//
//  Created by user on 12/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//

import Foundation
import Alamofire

typealias RequestResult = (_ success: Bool, _ responseObject: Any?, _ error: Error?) -> Void

class RequestManager {
    static let baseURL = "https://newsapi.org/v2/"
    static let apiKey = "apiKey=d99d0053c9284cd5b3afae0065c06428"
    static let language = "en"
    
    static func createFullURL(withParameters parametrs: String) -> String {
        return RequestManager.baseURL + parametrs + RequestManager.apiKey
    }
    
    static func defaultResponseAction(response: DataResponse<Any>?, completionHandler: RequestResult) {
        if let code = response?.response?.statusCode {
            completionHandler(code >= 200 && code <= 300, response?.result.value, response?.error)
        }
    }
}

