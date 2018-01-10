//
//  AllNewsViewController.swift
//  GlobalNewsPortal
//
//  Created by user on 14/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//

import UIKit
import CoreData
import Foundation

enum NewsVCState {
    case news
    case categories
}

class ActualNewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,UISideViewControllerDelegate  {
    
    @IBOutlet weak var articlesTableView: UITableView!
    
    @IBOutlet weak var sideMenuRightPositionConstraint: NSLayoutConstraint!
    
    private weak var sideMenuVC: UISideViewController?
    
    private var mode = NewsVCState.news
    private let refreshControl = UIRefreshControl()
    private var articles: [NotSavedArticle] = []
    private var categories: [String] = [""]
    private var selectedSection: [Int] = []
    private var keyWords: String?
    private var sortMode: SortMode = .popularity
    private var articlesByCategories: [(String, [NotSavedArticle])] = []
    private var sideMenuIsActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupTableView()
        self.fetchArticles(withKeyWords: nil, categoryNews: nil, afterFetchHandler: {
            self.articlesTableView.reloadData()
        })
        
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        self.tabBarController?.tabBar.barTintColor = .clear
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
    
    func setupUI() {
        self.sideMenuRightPositionConstraint.constant = self.view.frame.width * 2 / -3
    }
    
    func setupTableView() {
        self.articlesTableView.dataSource = self
        self.articlesTableView.delegate = self
        
        self.articlesTableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "articleCell")
        self.articlesTableView.register(UINib(nibName: "CategorySectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "categorySection")
        
        if #available(iOS 10.0, *) {
            self.articlesTableView.refreshControl = self.refreshControl
        } else {
            self.articlesTableView.addSubview(self.refreshControl)
        }
        
        self.refreshControl.addTarget(self, action: #selector(self.reloadData), for: UIControlEvents.valueChanged)
        self.refreshControl.backgroundColor = self.navigationController?.navigationBar.barTintColor
        self.refreshControl.tintColor = .white
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.mode {
        case .news:
            self.navigationController?.hidesBarsOnSwipe = true
            
            return 1
        case .categories:
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.hidesBarsOnSwipe = false
            
            return self.articlesByCategories.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.mode {
        case .news:
            return self.articles.count
        case .categories:
            return self.articlesByCategories[section].1.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UINib(nibName: "CategorySectionHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CategorySectionHeaderView
        let state = !self.articlesByCategories[section].1.isEmpty
        headerView.setup(withTitle: self.articlesByCategories[section].0, state: state, tappedHandler: { show in
            if show {
                self.fetchArticles(withKeyWords: self.keyWords, categoryNews: self.articlesByCategories[section].0, afterFetchHandler: {
                    self.articlesByCategories[section].1 = self.articles
                    self.articles = []
                    
                    var cellsIndexPath: [IndexPath] = []
                    
                    for (row, _) in self.articlesByCategories[section].1.enumerated() {
                        cellsIndexPath.append(IndexPath(item: row, section: section))
                    }
                    
                    if cellsIndexPath.count > 0 {
                        
                        headerView.isUserInteractionEnabled = false
                        
                        if #available(iOS 11.0, *) {
                            self.articlesTableView.performBatchUpdates( {
                                var sections = IndexSet()
                                sections.insert(section)
                                self.selectedSection.append(section)
                                self.articlesTableView.reloadSections(sections, with: .automatic)
                                self.articlesTableView.insertRows(at: cellsIndexPath, with: UITableViewRowAnimation.top)
                            }, completion: { success in
                                headerView.isUserInteractionEnabled = true
                            })
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                })
            } else {
                var cellsIndexPath: [IndexPath] = []
                for (row, _) in self.articlesByCategories[section].1.enumerated() {
                    cellsIndexPath.append(IndexPath(item: row, section: section))
                }
                if cellsIndexPath.count > 0 {
                    headerView.isUserInteractionEnabled = false
                    self.articlesByCategories[section].1 = []
                    if #available(iOS 11.0, *) {
                        self.articlesTableView.performBatchUpdates( {
                            var sections = IndexSet()
                            sections.insert(section)
                            self.selectedSection.remove(at: (self.selectedSection.enumerated().first(where: {$1 == section})!.offset))
                            self.articlesTableView.reloadSections(sections, with: .automatic)
                            self.articlesTableView.deleteRows(at: cellsIndexPath, with: UITableViewRowAnimation.bottom)
                        }, completion: { success in
                            headerView.isUserInteractionEnabled = true
                        })
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        })
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.articlesTableView.dequeueReusableCell(withIdentifier: "articleCell") as! ArticleCell
        
        var mode: ArticleCellMode!
        if indexPath.row % 2 == 0 {
            mode = .imageLeft
        } else {
            mode = .imageRight
        }
        
        switch self.mode {
        case .news:
            cell.setup(withArticle: self.articles[indexPath.row], andMode: mode)
        case .categories:
            cell.setup(withArticle: self.articlesByCategories[indexPath.section].1[indexPath.row], andMode: mode)
        }
        
        return cell
    }
    
    //MARK: UITableViewDelegate
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsDetailVC = storyboard?.instantiateViewController(withIdentifier: "newsDetailVC") as! NewsDetailViewController
        if self.mode == .categories {
            newsDetailVC.article = self.articlesByCategories[indexPath.section].1[indexPath.row]
        }
        else {
            newsDetailVC.article = self.articles[indexPath.row]
        }
        
        self.navigationController?.pushViewController(newsDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch self.mode {
        case .news:
            return 0
        case .categories:
            if self.selectedSection.contains(section) {
                return 50
            }
            return self.articlesTableView.frame.size.height / 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    //MARK: UISideViewControllerDelegate
    
    func dataForSideView() -> [String] {
        return ["1", "2", "3", "4", "5", "6"]
    }
    
    func search(byKeyWords keyWords: String?, selectedItems: [String]?, sortMode: SortMode?) {
        self.sideMenuIsActive = false
        self.articlesByCategories = []
        self.keyWords = keyWords
        
        if let mode = sortMode {
            self.sortMode = mode
        }
        
        if let items = selectedItems, !items.isEmpty {
            self.mode = .categories
            items.forEach({self.articlesByCategories.append(($0, []))})
            self.articlesTableView.reloadData()
            return
        } else {
            self.mode = .news
        }
        
        self.fetchArticles(withKeyWords: keyWords, categoryNews: nil, afterFetchHandler: {
            self.articlesTableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
    
    func cancel() {
        self.sideMenuIsActive = false
        
        UIView.animate(withDuration: 0.6, animations: {
            self.sideMenuRightPositionConstraint.constant = self.view.frame.width * 2 / -3
            self.view.layoutIfNeeded()
        })
        
        self.articlesTableView.isUserInteractionEnabled = true
    }
    
    //MARK Event Handlers
    
    @IBAction func showSideMenu(_ sender: Any) {
        if !self.sideMenuIsActive {
            UIView.animate(withDuration: 0.6, animations: {
                self.sideMenuRightPositionConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
            
        } else {
            UIView.animate(withDuration: 0.6, animations: {
                self.sideMenuRightPositionConstraint.constant = self.view.frame.width * 2 / -3
                self.view.layoutIfNeeded()
            })
        }
        
        self.sideMenuIsActive = !self.sideMenuIsActive
        self.articlesTableView.isUserInteractionEnabled = !self.sideMenuIsActive
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sideMenuVC" {
            self.sideMenuVC = segue.destination as? UISideViewController
            self.sideMenuVC?.deledate = self
        }
    }
    
    @objc func reloadData() {
        self.refreshControl.beginRefreshing()
        self.navigationController?.hidesBarsOnSwipe = true
        self.sortMode = .popularity
        self.keyWords = nil
        self.mode = .news
        self.articlesTableView.reloadData()
        self.selectedSection = []
        
        self.cancel()
        
        self.fetchArticles(withKeyWords: nil, categoryNews: nil, afterFetchHandler: {
            self.refreshControl.endRefreshing()
            self.articlesTableView.reloadData()
        })
    }
    
    func fetchArticles(withKeyWords keyWords: String?, categoryNews: String?, afterFetchHandler: @escaping ()->Void) {
        RequestManager.fetchArticles(byKeyWord: keyWords, categoryNews: categoryNews, completionHandler: {[weak self] success, result, error in
            if success, let json = result as? [String : Any?] {
                var newArticles: [NotSavedArticle] = []
                if let articlesJSON = json["articles"] as? [Any?] {
                    for articleJSON in articlesJSON {
                        newArticles.append(NotSavedArticle.parseArticle(fromRawObject: articleJSON))
                    }
                }
                if self?.sortMode == .date {
                    newArticles = newArticles.sorted(by: { firstItem, secondItem in
                        if secondItem.publishedAt != nil, let result = firstItem.publishedAt?.compare(secondItem.publishedAt! as Date) {
                            return result.rawValue > 0
                        }
                        return false
                    })
                }
                self?.articles = newArticles
                afterFetchHandler()
            }
        })
    }
}

