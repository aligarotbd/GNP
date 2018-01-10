//
//  SavedNewsViewController.swift
//  GlobalNewsPortal
//
//  Created by user on 14/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//

import UIKit
import CoreData
import WebKit

class SavedNewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
    
    private var fetchController: NSFetchedResultsController<Article>?
    private var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.hidesBarsOnSwipe = false
        
        super.viewWillDisappear(animated)
    }
    
    //MARK: Setup
    
    func setupTableView() {
        self.articleTableView.dataSource = self
        self.articleTableView.delegate = self
        
        self.articleTableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "articleCell")
        self.articleTableView.register(UINib(nibName: "CategorySectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "categorySection")
        
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.articleTableView.dequeueReusableCell(withIdentifier: "articleCell") as! ArticleCell
        
        var mode: ArticleCellMode!
        if indexPath.row % 2 == 0 {
            mode = .imageLeft
        } else {
            mode = .imageRight
        }
        
        cell.setup(withArticle: self.articles[indexPath.row], andMode: mode)
        
        if let image = self.articles[indexPath.row].image {
            cell.articleImageView.image = UIImage(data: image as Data)
        }
        
        return cell
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "AllNews", bundle: nil)
        let newsDetailVC = storyboard.instantiateViewController(withIdentifier: "newsDetailVC") as! NewsDetailViewController
        newsDetailVC.mode = .saved
        newsDetailVC.article = self.articles[indexPath.row]
        
        self.navigationController?.pushViewController(newsDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let articleCell = cell as? ArticleCell {
            articleCell.initialState()
            articleCell.animCellIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let articleCell = cell as? ArticleCell {
            articleCell.initialState()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    //MARK: NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.articles = self.fetchController!.fetchedObjects!
        
        self.articleTableView.reloadData()
    }
    
    //MARK: Event handlers
    
    //TODO: It will be implemented
    @IBAction func onSearchTapped(_ sender: Any) {
        print("searching ...")
    }
    
    func fetchData() {
        if self.fetchController == nil {
            let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
            self.fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchController?.delegate = self
        }
        
        try! self.fetchController?.performFetch()
        
        self.articles = self.fetchController!.fetchedObjects!
    }
}

