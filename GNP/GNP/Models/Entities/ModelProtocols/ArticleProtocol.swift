//
//  ArticleProtocol.swift
//  GlobalNewsPortal
//
//  Created by user on 13/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//

import Foundation

protocol ArticleProtocol {
    associatedtype myType: SourceProtocol
    
    var author: String? {get set}
    var image: NSData? {get set}
    var imageURL: String? {get set}
    var publishedAt: NSDate? {get set}
    var specification: String? {get set}
    var title: String? {get set}
    var url: String? {get set}
    var source: myType? {get set}
}

extension ArticleProtocol {
    
}

