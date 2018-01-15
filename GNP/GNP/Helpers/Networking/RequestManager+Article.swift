//
//  RequestManager+Article.swift
//  GlobalNewsPortal
//
//  Created by user on 12/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//

import Foundation
import Alamofire

enum SortMode: String {
    case date = "publishedAt"
    case popularity = "popularity"
}

extension RequestManager {
    static func fetchArticles(byKeyWord keyWord: String?, categoryNews: String?, completionHandler: @escaping RequestResult) {
        var parametrs = "top-headlines?language=en&"
        
        if let q = keyWord {
            parametrs.append("q=\(q)&")
        }
        
        if let category = categoryNews {
            parametrs.append("category=\(category)&")
        }
        
        let fullURL = RequestManager.createFullURL(withParameters: parametrs+"pageSize=100&")
        print(fullURL)
        Alamofire.request(fullURL).responseJSON(completionHandler: { response in
            RequestManager.defaultResponseAction(response: response, completionHandler: completionHandler)
        })
    }
}

