//
//  CategoryTableViewCell.swift
//  GNP
//
//  Created by user on 15/01/2018.
//  Copyright © 2018 CHI. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    var mainView: CategorySectionHeaderView!
    
    func setup(withTitle title: String) {
        if self.mainView == nil {
            self.mainView = UINib(nibName: String(describing: CategorySectionHeaderView.self), bundle: nil).instantiate(withOwner: nil, options: nil).first as! CategorySectionHeaderView
            self.mainView.frame = self.frame
            self.addSubview(self.mainView)
        }
        print(title)
        self.mainView.setup(withTitle: title, state: false, tappedHandler: nil)
    }
}
