//
//  String+Custom.swift
//  GlobalNewsPortal
//
//  Created by user on 13/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//

import Foundation

extension String
{
    static func isEmpty(_ string: String?) -> Bool {
        if let str = string {
            return str.isEmpty
        }
        
        return false
    }
    
    private var dateFormatter: DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }
    
    func toDate() -> Date?
    {
        return self.dateFormatter.date(from: self)
    }
}

