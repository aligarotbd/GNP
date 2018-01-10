//
//  TableViewCell.swift
//  GlobalNewsPortal
//
//  Created by user on 14/12/2017.
//  Copyright © 2017 chi. All rights reserved.
//

import UIKit

enum ArticleCellMode {
    case imageLeft
    case imageRight
}

class ArticleCell: UITableViewCell {
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDescriptionLabel: UILabel!
    
    @IBOutlet weak var imageViewSidePositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoViewSidePositionConstraint: NSLayoutConstraint!
    
    private var url: URL?
    private var currentMode: ArticleCellMode!
    private var readyForAnimate = false
    private var imageIsDownloaded = false {
        didSet{
            if self.readyForAnimate && self.imageIsDownloaded {
                DispatchQueue.main.async {
                    self.anim()
                }
            }
        }
    }
    
    var queue = OperationQueue()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.articleImageView?.image = #imageLiteral(resourceName: "defualt_news_image")
        self.queue.cancelAllOperations()
    }
    
    func setup<M: ArticleProtocol>(withArticle article: M, andMode mode: ArticleCellMode) {
        self.url = URL(string: article.imageURL ?? "")
        self.sourceNameLabel.text = article.source?.name
        self.articleTitleLabel.text = article.title
        self.articleDescriptionLabel.text = article.specification
        queue.maxConcurrentOperationCount = 1        
        if let url = self.url {
            print(queue.operations.count)
            queue.addOperation {
                do{
                    let data = try Data(contentsOf: url)
                    print(url == self.url)
                    if url == self.url {
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
                                self.articleImageView.alpha = 0.2
                            }, completion: { success in
                                self.articleImageView.image = UIImage(data: data)
                                self.articleImageView.alpha = 1
                                self.imageIsDownloaded = true
                            })
                        }
                    }
                } catch let error {
                    print(error)
                    self.imageIsDownloaded = true
                    self.readyForAnimate = true
                }
            }
        }
        
        self.currentMode = mode
    }
    
    //MARK Animation
    
    func initialState() {
        self.imageViewSidePositionConstraint.constant = 0
        self.infoViewSidePositionConstraint.constant = 0
        self.imageIsDownloaded = false
        self.readyForAnimate = false
    }
    
    func animCellIfNeeded() {
        self.readyForAnimate = true
        if self.url == nil {
            self.imageIsDownloaded = true
        }
    }
    
    private func anim() {
        if self.currentMode == .imageRight && self.readyForAnimate && self.imageIsDownloaded {
            self.imageViewSidePositionConstraint.constant = self.contentView.frame.width / 2
            self.infoViewSidePositionConstraint.constant = self.contentView.frame.width / 2
            UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
                self.contentView.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

