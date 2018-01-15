//
//  NewsDetailViewController.swift
//  GlobalNewsPortal
//
//  Created by user on 26/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//

import UIKit
import WebKit
import CoreData
import GradientCircularProgress

enum NewsDetailMode {
    case saved
    case notSaved
}

class NewsDetailViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var newsWebView: WKWebView!
    @IBOutlet weak var saveItem: UIBarButtonItem!
    
    @IBOutlet weak var initialView: UIView!
    
    var mode: NewsDetailMode = .notSaved
    var article: Any?
    
    private var progress: GradientCircularProgress!
    private var progressView: UIView!
    private var canSave = true
    private var loadFirstPage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newsWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.progress = GradientCircularProgress()
        self.progressView = self.progress.show(frame: CGRect(x: self.view.center.x - 50, y: self.initialView.center.y - 100, width: 100, height: 100), style: MyStyle())
        self.initialView.addSubview(self.progressView!)
                
        self.setupContent()
    }
    
    //MARK: Setup
    
    func setupContent() {
        self.newsWebView.navigationDelegate = self
        
        if mode == .notSaved {
            self.newsWebView.load(URLRequest(url: URL(string: (self.article as! NotSavedArticle).url!)!))
            
            self.saveItem.isEnabled = false
            self.checkSaving()
        } else {
            try! self.newsWebView.loadHTMLString(String(contentsOf: FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\((article as! Article).id).txt")), baseURL: URL(string: (self.article as! Article).url!))
            self.canSave = false
            self.saveItem.isEnabled = false
        }
    }
    
    //MARK: WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !self.loadFirstPage {
            UIView.animate(withDuration: 0.6, animations: {
                self.initialView.alpha = 0
            }, completion: { (success) in
                self.initialView.removeFromSuperview()
            })

            self.loadFirstPage = true
            if self.canSave {
                self.saveItem.isEnabled = true
            }
        }
    }
    
    //MARK: Event handlers
    
    @IBAction func save(_ sender: Any) {
        print("saving...")
        Article.save(article as! NotSavedArticle)
        
        self.checkSaving()
    }
    
    func checkSaving() {
        let fetchArticleRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchArticleRequest.predicate = NSPredicate(format: "url == %@", (article as! NotSavedArticle).url!)
        
        let articles: [Article] = try! context.fetch(fetchArticleRequest)
        
        if articles.count > 0 {
            self.canSave = false
            self.saveItem.isEnabled = false
        } else {
            self.canSave = true
            self.saveItem.isEnabled = true
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(self.newsWebView.estimatedProgress)
    }
}

