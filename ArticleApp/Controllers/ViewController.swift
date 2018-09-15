//
//  ViewController.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 8/26/18.
//  Copyright © 2018 Chhaileng Peng. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController, ArticlePresenterDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var articlePresenter: ArticlePresenter?
    
    var articles = [Article]()
    
    var newFetch = false
    var page = 1
    var countResponseArticle = 0
    
    // Loading at table view footer when scrolling
    var loadMore = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    // Loading pull to refresh
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articlePresenter = ArticlePresenter()
        articlePresenter?.delegate = self
        
        tableView.tableFooterView = loadMore
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshArticle), for: .valueChanged)
        
        SVProgressHUD.show()
        articlePresenter?.getArticles(page: page, limit: 30)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkArticleChanged), name: NSNotification.Name("articleChanged"), object: nil)
        
        
    }
    
    @objc func checkArticleChanged(notification: NSNotification) {
        let article = notification.userInfo!["article"] as! Article
        
        for i in 0...self.articles.count-1 {
            if articles[i].id == article.id {
                articles[i].title = article.title
                articles[i].description = article.description
                articles[i].image = article.image
                tableView.reloadData()
                return
            }
        }
        articles.insert(article, at: 0)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    @objc func refreshArticle() {
        page = 1
        articles = []
        SVProgressHUD.show()
        articlePresenter?.getArticles(page: page, limit: 15)
    }
    
    func responseArticles(articles: [Article]) {
        countResponseArticle = articles.count
        self.articles += articles
        SVProgressHUD.dismiss()
        refreshControl.endRefreshing()
        loadMore.stopAnimating()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func responseMessage(messaeg: String, article: Article) {
        let alert = UIAlertController(title: messaeg, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
            SVProgressHUD.show()
            self.articlePresenter?.getArticles(page: self.page, limit: 30)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell") as! ArticleTableViewCell
        cell.configureCell(article: articles[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // edit article code goes here
            let dest = self.storyboard?.instantiateViewController(withIdentifier: "AddArticleStoryboard") as! AddArticleViewController
            
            dest.articleId = self.articles[indexPath.row].id!
            dest.articleImage = self.articles[indexPath.row].image
            dest.articleTitle = self.articles[indexPath.row].title
            dest.articleDescription = self.articles[indexPath.row].description
            
            self.navigationController?.pushViewController(dest, animated: true)
        }
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete article code goes here
            self.articlePresenter?.deleteArticle(id: self.articles[indexPath.row].id!)
            self.articles.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        newFetch = false
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        newFetch = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if decelerate && newFetch && scrollView.contentOffset.y >= 0 && countResponseArticle > 0 {
            page = page + 1
            self.articlePresenter?.getArticles(page: page, limit: 15)
            loadMore.startAnimating()
            print(page)
            newFetch = false
        } else if !decelerate {
            newFetch = false
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

