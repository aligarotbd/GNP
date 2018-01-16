//
//  ArticlesByCategoryViewController.swift
//  GNP
//
//  Created by user on 16/01/2018.
//  Copyright © 2018 CHI. All rights reserved.
//

import UIKit

class ArticlesByCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PageScrollDelegate{
    @IBOutlet weak var articlesTableView: UITableView!
    
    var categoryID: String!
    
    private var articles: [NotSavedArticle] = []
    private var currentArticleIndex: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.fetchArticles(categoryNews: self.categoryID, afterFetchHandler: {
            self.articlesTableView.reloadData()
        })
    }
    
    func setupTableView() {
        self.articlesTableView.dataSource = self
        self.articlesTableView.delegate = self
        
        self.articlesTableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "articleCell")
        
        self.articlesTableView.backgroundColor = .appColor
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.articlesTableView.dequeueReusableCell(withIdentifier: "articleCell") as! ArticleCell
        
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
        self.currentArticleIndex = indexPath
        
        let storyboard = UIStoryboard(name: "AllNews", bundle: nil)
        let newsDetailVC = storyboard.instantiateViewController(withIdentifier: "newsDetailVC") as! NewsDetailViewController
        newsDetailVC.delegate = self
        
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
    
    func startArticle<A>() -> A where A : ArticleProtocol {
        return articles[self.currentArticleIndex.row] as! A
    }
    
    func nextArticle<A>() -> A where A : ArticleProtocol {
        self.currentArticleIndex.row += 1
        
        if self.currentArticleIndex.row == self.articles.count {
            self.currentArticleIndex.row = 0
        }
        
        return self.articles[self.currentArticleIndex.row] as! A
    }
    
    func previousArticle<A>() -> A where A : ArticleProtocol {
        self.currentArticleIndex.row -= 1
        
        if self.currentArticleIndex.row < 0 {
            self.currentArticleIndex.row = self.articles.count - 1
        }
        
        return self.articles[self.currentArticleIndex.row] as! A
    }
    
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
