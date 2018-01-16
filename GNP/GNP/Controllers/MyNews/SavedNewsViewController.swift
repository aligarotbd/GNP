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

class SavedNewsViewController: UIViewController, ArticlesTableViewDataSource, ArticlesTableViewDelegate, NSFetchedResultsControllerDelegate, PageScrollDelegate{
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
    
    private var articlesTableView: ArticlesTableView?
    private var fetchController: NSFetchedResultsController<Article>?
    private var articles: [Article] = []
    private var currentArticleIndex: IndexPath!
    
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
        self.articlesTableView = UINib(nibName: "ArticlesTableView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? ArticlesTableView
        self.articlesTableView?.frame = self.mainView.frame
        self.mainView.addSubview(self.articlesTableView!)
        self.articlesTableView?.dataSource = self
        self.articlesTableView?.delegate = self
        self.articlesTableView?.setupTableView()
    }
    
    //MARK: ArticlesTableViewDelegate
    
    func selectArticle(withIndexPath indexPath: IndexPath) {
        self.currentArticleIndex = indexPath
        
        let storyboard = UIStoryboard(name: "AllNews", bundle: nil)
        let newsDetailVC = storyboard.instantiateViewController(withIdentifier: "newsDetailVC") as! NewsDetailViewController
        newsDetailVC.delegate = self
        newsDetailVC.mode = .saved
        
        self.navigationController?.pushViewController(newsDetailVC, animated: true)
    }
    
    //MARK: ArticlesTableViewDataSource
    
    func getArticles() -> [ArticleProtocol] {
        return self.articles
    }
    
    //MARK: NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.articles = self.fetchController!.fetchedObjects!
        
        self.articlesTableView?.reloadTable()
    }
    
    func startArticle() -> ArticleProtocol {
        return articles[self.currentArticleIndex.row]
    }
    
    //MARK: PageScrollDelegate
    
    func nextArticle() -> ArticleProtocol {
        self.currentArticleIndex.row += 1
        
        if self.currentArticleIndex.row == self.articles.count {
            self.currentArticleIndex.row = 0
        }
        
        return self.articles[self.currentArticleIndex.row]
    }
    
    func previousArticle() -> ArticleProtocol {
        self.currentArticleIndex.row -= 1
        
        if self.currentArticleIndex.row < 0 {
            self.currentArticleIndex.row = self.articles.count - 1
        }
        
        return self.articles[self.currentArticleIndex.row] 
    }
    
    //MARK: Event handlers
    
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

