//
//  SideMenuItemCollectionViewCell.swift
//  GlobalNewsPortal
//
//  Created by user on 18/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//

import UIKit

class SideMenuItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    
    func setup(withStr str: String) {
        self.itemLabel.text = str
    }
    
    func changeSate() {
        if self.isSelected {
            self.itemLabel.backgroundColor = .appColor
            self.itemLabel.textColor = .articleColor
        } else {
            self.itemLabel.backgroundColor = .articleColor
            self.itemLabel.textColor = .appColor
        }
    }
}

