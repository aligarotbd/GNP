//
//  Category+CoreDataClass.swift
//  GlobalNewsPortal
//
//  Created by user on 11/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    
    static func getObj(fromRawObject rawObject: Any?) {
        if let json = rawObject as? [String : Any?] {
            let category = Category()
            category.id = json["id"] as? String
        }
    }
}

