//
//  CategoryTableViewCell.swift
//  GNP
//
//  Created by user on 15/01/2018.
//  Copyright © 2018 CHI. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    func setup(withTitle title: String) {
        let view  = CategorySectionHeaderView()
        view.frame = self.frame
        self.addSubview(view)
        
        view.setup(withTitle: title, state: false, tappedHandler: nil)
    }
}
