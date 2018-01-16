//
//  PageScrollDelegate.swift
//  GNP
//
//  Created by user on 15/01/2018.
//  Copyright © 2018 CHI. All rights reserved.
//

import Foundation

protocol PageScrollDelegate {
    func startArticle() -> ArticleProtocol
    
    func nextArticle() -> ArticleProtocol
    func previousArticle() -> ArticleProtocol
}
