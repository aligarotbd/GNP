//
//  Source+CoreDataProperties.swift
//  GlobalNewsPortal
//
//  Created by user on 11/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//
//

import Foundation
import CoreData


extension Source {
    
    @nonobjc public class func fetchRequest<Source>() -> NSFetchRequest<Source> {
        return NSFetchRequest<Source>(entityName: "Source")
    }
    
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var articles: Set<Article>?
    @NSManaged public var category: Category?
}

// MARK: Generated accessors for articles

extension Source {
    
    @objc(addArticlesObject:)
    @NSManaged public func addToArticles(_ value: Article)
    
    @objc(removeArticlesObject:)
    @NSManaged public func removeFromArticles(_ value: Article)
    
}

