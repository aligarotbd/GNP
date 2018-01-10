//
//  Article+CoreDataClass.swift
//  GlobalNewsPortal
//
//  Created by user on 11/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//
//

import Foundation
import CoreData
import  UIKit

@objc(Article)
public class Article: NSManagedObject, ArticleProtocol {
    var imageURL: String?
    
    static func save(_ notSavedArticle: NotSavedArticle) {
        let article = Article(context: context)
        
        article.author = notSavedArticle.author
        article.publishedAt = notSavedArticle.publishedAt
        article.title = notSavedArticle.title
        article.specification = notSavedArticle.specification
        article.url = notSavedArticle.url
        
        URLSession.shared.dataTask(with: URL(string: notSavedArticle.imageURL!)!) { data, _, _ in
            article.image = data! as NSData
            }.resume()
        
        
        let fetchSourceRequest: NSFetchRequest<Source> = Source.fetchRequest()
        let sources: [Source] = try! context.fetch(fetchSourceRequest)
        for source in sources {
            if source.id == notSavedArticle.source?.id {
                article.source = source
            }
        }
        if article.source == nil {
            let source = Source(context: context)
            source.id = notSavedArticle.source?.id
            source.name = notSavedArticle.source?.name
            
            article.source = source
        }
        
        article.id = self.generateID()
        
        do{
            let text = try String(contentsOf: URL(string: article.url!)!)
            let file = "\(article.id).txt"
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let fileURL = dir.appendingPathComponent(file)
                
                do {
                    try text.write(to: fileURL, atomically: false, encoding: .utf8)
                }
                catch let error {print(error)}
                
            }
        } catch let error {print(error)}
        
        try! context.save()
    }
    
    static func generateID() -> Int64{
        let fetchArticleRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchArticleRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let articles: [Article] = try! context.fetch(fetchArticleRequest)
        if let article = articles.first {
            return article.id + 1
        }
        
        return 1
    }
}
