//
//  ArticlesByCategoryViewController.swift
//  GNP
//
//  Created by user on 16/01/2018.
//  Copyright © 2018 CHI. All rights reserved.
//

import UIKit

class ArticlesByCategoryViewController: UIViewController, ArticlesTableViewDataSource, ArticlesTableViewDelegate, PageScrollDelegate {
    @IBOutlet weak var mainView: UIView!
    
    var categoryID: String!
    
    private var articles: [NotSavedArticle] = []
    private var currentArticleIndex: IndexPath!
    private var articlesTableView: ArticlesTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchArticles(categoryNews: self.categoryID, afterFetchHandler: {
            self.setupTableView()
        })
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
        
        self.navigationController?.pushViewController(newsDetailVC, animated: true)
    }
    
    //MARK: ArticlesTableViewDataSource
    
    func getArticles() -> [ArticleProtocol] {
        return self.articles
    }
    
    //MARK: PageScrollDelegate
    
    func startArticle() -> ArticleProtocol {
        return articles[self.currentArticleIndex.row]
    }
    
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
    
    //MARK: Fetch data
    
    func fetchArticles(categoryNews: String?, afterFetchHandler: @escaping ()->Void) {
        RequestManager.fetchArticles(byKeyWord: nil, categoryNews: categoryNews, completionHandler: {[weak self] success, result, error in
            if success, let json = result as? [String : Any?] {
                var newArticles: [NotSavedArticle] = []
                if let articlesJSON = json["articles"] as? [Any?] {
                    for articleJSON in articlesJSON {
                        newArticles.append(NotSavedArticle.parseArticle(fromRawObject: articleJSON))
                    }
                }
                
                self?.articles = newArticles
                afterFetchHandler()
            }
        })
    }
}
