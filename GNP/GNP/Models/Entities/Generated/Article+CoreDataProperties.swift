//
//  Article+CoreDataProperties.swift
//  GlobalNewsPortal
//
//  Created by user on 11/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {
    
    @nonobjc public class func fetchRequest<Article>() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var author: String?
    @NSManaged public var image: NSData?
    @NSManaged public var publishedAt: NSDate?
    @NSManaged public var specification: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var source: Source?
}

