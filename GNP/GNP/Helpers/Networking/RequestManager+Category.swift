//
//  RequestManager+Category.swift
//  GlobalNewsPortal
//
//  Created by user on 12/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//

import Foundation
import Alamofire

extension RequestManager {
    static func fetchAllSourses(completionHandler: @escaping RequestResult) {
        let fullURL = RequestManager.createFullURL(withParameters: "sources?language=\(RequestManager.language)&")
        
        Alamofire.request(fullURL).responseJSON(completionHandler: { response in
            RequestManager.defaultResponseAction(response: response, completionHandler: completionHandler)
        })
    }
    
    static func fetchSourses(ByCategoryID categoryID: String, completionHandler: @escaping RequestResult) {
        let fullURL = RequestManager.createFullURL(withParameters: "sources?language=\(RequestManager.language)&category=\(categoryID)&")
        
        Alamofire.request(fullURL).responseJSON(completionHandler: { response in
            RequestManager.defaultResponseAction(response: response, completionHandler: completionHandler)
        })
    }
}

