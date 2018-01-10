//
//  Source+CoreDataClass.swift
//  GlobalNewsPortal
//
//  Created by user on 11/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Source)
public class Source: NSManagedObject, SourceProtocol {
    
    static func createSource(fromRawObject rawObject: Any?) -> Source? {
        if let json = rawObject as? [String : Any?] {
            let source = Source(context: context)
            source.id = json["id"] as? String
            source.name = json["name"] as? String
            
            guard let categoryID = json["category"] as? String else {
                return nil
            }
            
            let fetchCategoryRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchCategoryRequest.predicate = NSPredicate(format: "id == %@", categoryID)
            
            guard let category: Category = try! context.fetch(fetchCategoryRequest).first else {
                return nil
            }
            source.category = category
            
            try! context.save()
            
            return source
        }
        
        return nil
    }
}

