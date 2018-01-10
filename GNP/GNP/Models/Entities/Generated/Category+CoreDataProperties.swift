//
//  Category+CoreDataProperties.swift
//  GlobalNewsPortal
//
//  Created by user on 11/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {
    
    static func fetchRequest<Category>() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }
    
    @NSManaged public var id: String?
    @NSManaged public var sources: NSSet?
}

// MARK: Generated accessors for sources

extension Category {
    
    @objc(addSourcesObject:)
    @NSManaged public func addToSources(_ value: Source)
    
    @objc(removeSourcesObject:)
    @NSManaged public func removeFromSources(_ value: Source)
    
    @objc(addSources:)
    @NSManaged public func addToSources(_ values: NSSet)
    
    @objc(removeSources:)
    @NSManaged public func removeFromSources(_ values: NSSet)
}

