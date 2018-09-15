//
//  AddArticleViewController.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 9/8/18.
//  Copyright © 2018 Chhaileng Peng. All rights reserved.
//

import UIKit
import Kingfisher

class AddArticleViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var articlePresenter: ArticlePresenter?
    var imagePicker: UIImagePickerController?
    
    var articleId = 0
    var articleImage: String?
    var articleTitle: String?
    var articleDescription: String?
    
    @IBAction func save(_ sender: UIButton) {
        
        // validation
        if descriptionTextView.text.trimmingCharacters(in: .whitespaces) == "" || descriptionTextView.text == nil || titleTextField.text?.trimmingCharacters(in: .whitespaces) == "" || titleTextField.text == nil {
            print("Validation failed")
            return
        }
        
        let article = Article()
        article.id = articleId
//        article.title = titleTextField.text?.trimmingCharacters(in: .whitespaces)
        
        article.title = titleTextField.text?.trimSpace
        article.description = descriptionTextView.text.trimmingCharacters(in: .whitespaces)
//        article.image = "https://pbs.twimg.com/profile_images/948761950363664385/Fpr2Oz35_400x400.jpg"
        
//        articlePresenter?.insertArticle(article: article)
        let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
        articlePresenter?.uploadImage(data: imageData!, article: article)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articlePresenter = ArticlePresenter()
        articlePresenter?.delegate = self
        
        if articleId != 0 {
            self.title = "Update Article"
            imageView.kf.setImage(with: URL(string: articleImage!))
            titleTextField.text = articleTitle!
            descriptionTextView.text = articleDescription
        }
        
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func pickImage() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action) in
            self.imagePicker?.sourceType = .photoLibrary
            self.present(self.imagePicker!, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.imagePicker?.sourceType = .camera
            self.present(self.imagePicker!, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension AddArticleViewController: ArticlePresenterDelegate {
    func responseArticles(articles: [Article]) { }
    
    func responseMessage(messaeg: String, article: Article) {
        print(article.id!)
        
        NotificationCenter.default.post(name: NSNotification.Name("articleChanged"), object: nil, userInfo: ["article": article])
        
        let alert = UIAlertController(title: messaeg, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension AddArticleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        }
        
        self.imagePicker?.dismiss(animated: true, completion: nil)
    }
    
}





extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    var trimSpace: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}

class CustomValidate {
    
    static func trimSpace(string: String) -> String {
        return string.trimmingCharacters(in: .whitespaces)
    }
    
}










