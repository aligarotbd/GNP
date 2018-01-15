//
//  UISideView.swift
//  GlobalNewsPortal
//
//  Created by user on 15/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//

import UIKit

protocol UISideViewControllerDelegate {
    func dataForSideView() -> [String]
    func search(byKeyWords keyWords: String?, selectedItems:[String]?, sortMode: SortMode?)
    func cancel()
}

class UISideViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sideMenuCollectionView: UICollectionView!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var searhTextField: UITextField!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var titleForSegment: UILabel!
    
    @IBOutlet weak var topCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewButtonConstraint: NSLayoutConstraint!
    var deledate: UISideViewControllerDelegate?
    
    private var selectedItems: [Int : String] = [:]
    private var allCategories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDataSource()
        
        self.searhTextField.delegate = self
        self.sideMenuCollectionView.dataSource = self
        self.sideMenuCollectionView.delegate = self
        self.sideMenuCollectionView.allowsMultipleSelection = true
    }
    
    func showOnlyCollectionView() {
        self.titleForSegment.isHidden = true
        self.searhTextField.isHidden = true
        self.sortSegmentedControl.isHidden = true
        self.leftButton.setTitle("Save", for: .normal)
        
        self.tableViewButtonConstraint.isActive = false
        self.tableViewButtonConstraint = NSLayoutConstraint(item: self.sideMenuCollectionView, attribute: .bottom, relatedBy: .equal, toItem: self.sideMenuCollectionView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        self.tableViewButtonConstraint.isActive = true
        
        self.topCollectionViewConstraint.isActive = false
        self.topCollectionViewConstraint = NSLayoutConstraint(item: self.sideMenuCollectionView, attribute: .top, relatedBy: .equal, toItem: self.sideMenuCollectionView.superview, attribute: .top, multiplier: 1, constant: 10)
        self.topCollectionViewConstraint.isActive = true
        
        self.sideMenuCollectionView.reloadData()
    }

    private func setupDataSource() {
        self.allCategories = self.deledate!.dataForSideView()
    }
    
    //MARK UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sideViewCell = sideMenuCollectionView.dequeueReusableCell(withReuseIdentifier: "sideMenuCell", for: indexPath) as! SideMenuItemCollectionViewCell
        sideViewCell.setup(withStr: self.allCategories[indexPath.row])
        
        return sideViewCell
    }
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = self.sideMenuCollectionView.cellForItem(at: indexPath) as! SideMenuItemCollectionViewCell
        cell.changeSate()
        
        self.selectedItems[indexPath.row] = allCategories[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = self.sideMenuCollectionView.cellForItem(at: indexPath) as! SideMenuItemCollectionViewCell
        cell.isSelected = false
        cell.changeSate()

        self.selectedItems.removeValue(forKey: indexPath.row)
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 2 - 15, height: self.sideMenuCollectionView.frame.height / 5 - 10
        )
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searhTextField.resignFirstResponder()
        
        return true
    }
    
    //MARK: Event handlers

    @IBAction func editingDidBeginOnSearch(_ sender: Any) {
        self.searchImage.isHidden = true
    }
    
    @IBAction func editingDidEndOnSearch(_ sender: Any) {
        if String.isEmpty(self.searhTextField.text) {
            self.searchImage.isHidden = false
        }
    }
    
    @IBAction func onSearchTapped(_ sender: Any) {
        let sortMode: SortMode?
        
        switch self.sortSegmentedControl.titleForSegment(at: self.sortSegmentedControl.selectedSegmentIndex)! {
        case "date":
            sortMode = .date
        case "Popularity":
            sortMode = SortMode.popularity
        default:
            sortMode = nil
        }
        
        self.deledate?.search(byKeyWords: self.searhTextField.text!, selectedItems: Array(self.selectedItems.values), sortMode: sortMode)
        self.deledate?.cancel()
    }
    
    @IBAction func onCancelTapped(_ sender: Any) {
        self.deledate?.cancel()
        
        self.searhTextField.text = ""
        self.searchImage.isHidden = false
        self.sortSegmentedControl.selectedSegmentIndex = 0
        if let selectedItems = self.sideMenuCollectionView.indexPathsForSelectedItems {
            for indexPath in selectedItems {
                self.collectionView(self.sideMenuCollectionView, didDeselectItemAt: indexPath)
            }
        }
    }
}

