//
//  Category+CoreDataProperties.swift
//  GNP
//
//  Created by user on 15/01/2018.
//  Copyright © 2018 CHI. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    static func fetchRequest<Category>() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var id: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var sources: NSSet?

}
