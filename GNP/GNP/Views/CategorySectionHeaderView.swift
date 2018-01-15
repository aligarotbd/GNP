//
//  CategorySectionHeaderView.swift
//  GlobalNewsPortal
//
//  Created by user on 19/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//

import UIKit

class CategorySectionHeaderView: UIView {
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    var afterTapeedHandler: ((Bool) -> Void)?
    
    private var displayArticles = false
    private var initialHeigth: CGFloat!
    
    
    func setup(withTitle title: String, state: Bool, tappedHandler:((Bool) -> Void)?) {
        self.titelLabel.text = title
        self.categoryImageView.image = UIImage(named: title)
        self.displayArticles = state
        self.afterTapeedHandler = tappedHandler
        self.initialHeigth = self.frame.height
        
        if tappedHandler != nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.changeState))
            self.addGestureRecognizer(tap)
        }
    }
    
    @objc func changeState() {
        if let handler = self.afterTapeedHandler {
            self.isUserInteractionEnabled = false
            self.displayArticles = !self.displayArticles
        
            handler(self.displayArticles)
        }
    }
}

