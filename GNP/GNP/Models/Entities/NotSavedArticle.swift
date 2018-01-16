//
//  Article.swift
//  GlobalNewsPortal
//
//  Created by user on 13/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//

import Foundation

class  NotSavedArticle: ArticleProtocol {
    var author: String?
    var image: NSData?
    var imageURL: String?
    var publishedAt: NSDate?
    var specification: String?
    var title: String?
    var url: String?
    var sourceArticle: SourceProtocol?
    
    static func parseArticle(fromRawObject rawObject: Any?) -> NotSavedArticle {
        let article = NotSavedArticle()
        
        if let json = rawObject as? [String : Any?] {
            article.author = json["author"] as? String
            article.imageURL = json["urlToImage"] as? String
            
            if let publishedAt = json["publishedAt"] as? String {
                article.publishedAt = publishedAt.toDate() as NSDate?
            }
            
            article.specification = json["description"] as? String
            article.title = json["title"] as? String
            article.url = json["url"] as? String
            
            if let sourceJSON = json["source"] as? [String : Any?] {
                article.sourceArticle = NotSavedSource()
                article.sourceArticle?.id = sourceJSON["id"] as? String
                article.sourceArticle?.name = sourceJSON["name"] as? String
            }
        }
        
        return article
    }
}

