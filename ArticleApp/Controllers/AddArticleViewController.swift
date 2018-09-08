//
//  AddArticleViewController.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 9/8/18.
//  Copyright © 2018 Chhaileng Peng. All rights reserved.
//

import UIKit

class AddArticleViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var articlePresenter: ArticlePresenter?
    
    @IBAction func save(_ sender: UIButton) {
        let article = Article()
        article.title = titleTextField.text
        article.description = descriptionTextView.text
        article.image = "https://pbs.twimg.com/profile_images/948761950363664385/Fpr2Oz35_400x400.jpg"
        
        articlePresenter?.insertArticle(article: article)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articlePresenter = ArticlePresenter()
        articlePresenter?.delegate = self
    }

}

extension AddArticleViewController: ArticlePresenterDelegate {
    func responseArticles(articles: [Article]) { }
    
    func responseMessage(messaeg: String) {
        print(messaeg)
        let alert = UIAlertController(title: messaeg, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
