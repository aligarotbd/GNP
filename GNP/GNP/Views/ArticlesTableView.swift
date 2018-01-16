//
//  ArticlesTableView.swift
//  GNP
//
//  Created by user on 16.01.18.
//  Copyright © 2018 CHI. All rights reserved.
//

import UIKit

protocol ArticlesTableViewDataSource {
    func getArticles() -> [ArticleProtocol]
}

protocol ArticlesTableViewDelegate {
    func selectArticle(withIndexPath indexPath: IndexPath)
}

class ArticlesTableView: UIView, UITableViewDataSource ,UITableViewDelegate {
    @IBOutlet weak var articlesTableView: UITableView!
    
    var dataSource: ArticlesTableViewDataSource?
    var delegate: ArticlesTableViewDelegate?
    var currentNewsIndex: IndexPath?
    var selectedSection: [Int] = []
    
    func setupTableView() {
        
        self.articlesTableView.dataSource = self
        self.articlesTableView.delegate = self
        
        self.articlesTableView.backgroundColor = .appColor
        
        self.articlesTableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "articleCell")
        self.articlesTableView.register(UINib(nibName: "CategorySectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "categorySection")
        self.articlesTableView.reloadData()
    }
    
    func reloadTable() {
        self.articlesTableView.reloadData()
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource!.getArticles().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.articlesTableView.dequeueReusableCell(withIdentifier: "articleCell") as! ArticleCell
        
        var mode: ArticleCellMode!
        if indexPath.row % 2 == 0 {
            mode = .imageLeft
        } else {
            mode = .imageRight
        }
        
        cell.setup(withArticle: self.dataSource!.getArticles()[indexPath.row], andMode: mode)
        
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
        self.currentNewsIndex = indexPath
        
        self.delegate?.selectArticle(withIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
