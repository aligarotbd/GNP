//
//  FavoritesCategoriesViewController.swift
//  GNP
//
//  Created by user on 15/01/2018.
//  Copyright © 2018 CHI. All rights reserved.
//

import UIKit
import CoreData

class FavoritesCategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISideViewControllerDelegate {
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var sideMenu: UIView!
    
    @IBOutlet weak var sideMenuRightConstraint: NSLayoutConstraint!
    
    var sideMenuVC: UISideViewController!
    
    var categories: [Category] = []
    var sideMenuIsActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.setupContent()
    }
    
    private func  setupContent() {
        self.fetchData()
        self.setupUI()
        
        self.sideMenuVC.showOnlyCollectionView()
    }
    
    private func setupUI() {
        self.sideMenuRightConstraint.constant = self.view.frame.width * 2 / -3
        self.categoriesTableView.backgroundColor = .appColor
    }
    
    private func setupTableView() {
        self.categoriesTableView.delegate = self
        self.categoriesTableView.dataSource = self
        self.categoriesTableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.categoriesTableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryCell
        cell.setup(withTitle: self.categories[indexPath.row].id!)
        return cell
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.categoriesTableView.frame.height / 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articlesVC = self.storyboard?.instantiateViewController(withIdentifier: "ArticlesByCategory") as! ArticlesByCategoryViewController
        articlesVC.categoryID = self.categories[indexPath.row].id!
        
        self.navigationController?.pushViewController(articlesVC, animated: true)
    }
    
    //MARK: UISideViewControllerDelegate
    
    func dataForSideView() -> [String] {
        return try! context.fetch(Category.fetchRequest() as! NSFetchRequest<Category>).map({$0.id!})
    }
    
    func search(byKeyWords keyWords: String?, selectedItems: [String]?, sortMode: SortMode?) {
        if let selectedCategories = selectedItems {
            let savedCategories = try! context.fetch(Category.fetchRequest() as! NSFetchRequest<Category>)
            savedCategories.forEach { (item) in
                if selectedCategories.contains(item.id!) {
                    item.isFavorite = true
                } else {
                    item.isFavorite = false
                }
            }
            
            try! context.save()
        }
        self.fetchData()
        self.cancel()
    }
    
    func cancel() {
        self.sideMenuIsActive = false
        
        self.sideMenuRightConstraint.constant = self.view.frame.width * 2 / -3
        UIView.animate(withDuration: 0.6, animations: {
            self.view.layoutIfNeeded()
        })
        
        self.categoriesTableView.isUserInteractionEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sideMenuVC" {
            self.sideMenuVC = segue.destination as? UISideViewController
            self.sideMenuVC?.deledate = self
        }
    }
    
    @IBAction func onConfigTapped(_ sender: Any) {
        if !self.sideMenuIsActive {
            UIView.animate(withDuration: 0.6, animations: {
                self.sideMenuRightConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
            
        } else {
            UIView.animate(withDuration: 0.6, animations: {
                self.sideMenuRightConstraint.constant = self.view.frame.width * 2 / -3
                self.view.layoutIfNeeded()
            })
        }
        
        self.sideMenuIsActive = !self.sideMenuIsActive
        self.categoriesTableView.isUserInteractionEnabled = !self.sideMenuIsActive
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        self.categories = try! context.fetch(fetchRequest)
        self.categoriesTableView.reloadData()
    }
}
