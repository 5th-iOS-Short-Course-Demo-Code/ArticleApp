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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.show()
        articlePresenter?.getArticles(page: 1, limit: 30)
    }

    func responseArticles(articles: [Article]) {
        self.articles = articles
        SVProgressHUD.dismiss()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func responseMessage(messaeg: String) {
        let alert = UIAlertController(title: messaeg, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
            SVProgressHUD.show()
            self.articlePresenter?.getArticles(page: 1, limit: 30)
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
            let alert = UIAlertController(title: "Update Article", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "New Title"
                textField.text = self.articles[indexPath.row].title
            })
            
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
                self.articles[indexPath.row].title = alert.textFields?.first?.text
                self.articlePresenter?.updateArticle(article: self.articles[indexPath.row])
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete article code goes here
            self.articlePresenter?.deleteArticle(id: self.articles[indexPath.row].id!)
            self.articles.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [delete, edit]
    }
    
    
    
    
    
    
    
    
    
    
    
    
}

