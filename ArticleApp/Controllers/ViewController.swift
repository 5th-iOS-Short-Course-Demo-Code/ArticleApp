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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articlePresenter = ArticlePresenter()
        articlePresenter?.delegate = self
        SVProgressHUD.show()
        articlePresenter?.getArticles(page: 1, limit: 30)
        
    }

    func responseArticles(articles: [Article]) {
//        for article in articles {
//            print(article.title!)
//        }
        self.articles = articles
        SVProgressHUD.dismiss()
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
    
    
}

