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
    var imagePicker: UIImagePickerController?
    
    @IBAction func save(_ sender: UIButton) {
        let article = Article()
        article.id = 0
        article.title = titleTextField.text
        article.description = descriptionTextView.text
//        article.image = "https://pbs.twimg.com/profile_images/948761950363664385/Fpr2Oz35_400x400.jpg"
        
//        articlePresenter?.insertArticle(article: article)
        let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
        articlePresenter?.uploadImage(data: imageData!, article: article)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articlePresenter = ArticlePresenter()
        articlePresenter?.delegate = self
        
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
    
    func responseMessage(messaeg: String) {
        print(messaeg)
        let alert = UIAlertController(title: messaeg, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
