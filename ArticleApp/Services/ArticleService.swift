//
//  ArticleService.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 8/26/18.
//  Copyright © 2018 Chhaileng Peng. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

/*

// Request URL using URLSession
class ArticleService {
    
    let ARTICLE_URL = "http://35.240.238.182:8080/v1/api/articles"
    
    var delegate: ArticleServiceDelegate?
    
    func getArticles(page: Int, limit: Int) {
        var request = URLRequest(url: URL(string: "\(ARTICLE_URL)?page=\(page)&limit=\(limit)")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                // data get success
                let json = try? JSON(data: data!)
                let articleJsonArray = json!["DATA"].array
                
                var articles = [Article]()
                for articleJson in articleJsonArray! {
                    articles.append(Article(json: articleJson))
                }
                self.delegate?.responseArticles(articles: articles)
            }
        }.resume()
    }
    
    func insertArticle(article: Article) {
        var request = URLRequest(url: URL(string: ARTICLE_URL)!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=", forHTTPHeaderField: "Authorization")
        
        let articleDict: [String: Any] = [
            "TITLE": article.title!,
            "DESCRIPTION": article.description!,
            "AUTHOR": 1,
            "CATEGORY_ID": 1,
            "STATUS": "true",
            "IMAGE": article.image!
        ]
        
        let articleData = try? JSONSerialization.data(withJSONObject: articleDict, options: [])
        
        request.httpBody = articleData
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                let json = try? JSON(data: data!)
                let message = json!["MESSAGE"].string
                self.delegate?.responseMessage(message: message!)
            }
        }.resume()
        
    }
    
    
    func deleteArticle(id: Int) {
        var request = URLRequest(url: URL(string: "\(ARTICLE_URL)/\(id)")!)
        
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                let json = try? JSON(data: data!)
                let message = json!["MESSAGE"].string
                self.delegate?.responseMessage(message: message!)
            }
        }.resume()
    }
    
    func updateArticle(article: Article) {
        var request = URLRequest(url: URL(string: "\(ARTICLE_URL)/\(article.id!)")!)
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=", forHTTPHeaderField: "Authorization")
        
        let articleDict: [String: Any] = [
            "TITLE": article.title!,
            "DESCRIPTION": article.description!,
            "AUTHOR": 1,
            "CATEGORY_ID": 1,
            "STATUS": "true",
            "IMAGE": article.image!
        ]
        
        let articleData = try? JSONSerialization.data(withJSONObject: articleDict, options: [])
        
        request.httpBody = articleData
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                let json = try? JSON(data: data!)
                let message = json!["MESSAGE"].string
                self.delegate?.responseMessage(message: message!)
            }
        }.resume()
    }
    
}

*/


// Request URL using Alamofire
class ArticleService {
    
    let ARTICLE_URL = "http://35.240.238.182:8080/v1/api/articles"
    let UPLOAD_URL = "http://35.240.238.182:8080/v1/api/uploadfile/single"
    let HEADERS = [
        "Authorization": "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=",
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    
    var delegate: ArticleServiceDelegate?
    
    func getArticles(page: Int, limit: Int) {
        
        Alamofire.request("\(ARTICLE_URL)?page=\(page)&limit=\(limit)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADERS).responseJSON { (response) in
            if response.result.isSuccess {
                let json = try? JSON(data: response.data!)
                let articleJsonArray = json!["DATA"].array
                
                var articles = [Article]()
                for articleJson in articleJsonArray! {
                    articles.append(Article(json: articleJson))
                }
                self.delegate?.responseArticles(articles: articles)
            }
        }
        
    }
    
    func insertArticle(article: Article) {
        
        let params: [String: Any] = [
            "TITLE": article.title!,
            "DESCRIPTION": article.description!,
            "AUTHOR": 1,
            "CATEGORY_ID": 1,
            "STATUS": "true",
            "IMAGE": article.image!
        ]
        
        Alamofire.request(ARTICLE_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADERS).responseJSON { (response) in
            if response.result.isSuccess {
                let json = try? JSON(data: response.data!)
                let message = json!["MESSAGE"].string
                self.delegate?.responseMessage(message: message!)
            }
        }
        
    }
    
    
    func deleteArticle(id: Int) {
        
        Alamofire.request("\(ARTICLE_URL)/\(id)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: HEADERS).responseJSON { (response) in
            if response.result.isSuccess {
                let json = try? JSON(data: response.data!)
                let message = json!["MESSAGE"].string
                self.delegate?.responseMessage(message: message!)
            }
        }
    }
    
    func updateArticle(article: Article) {
        let params: [String: Any] = [
            "TITLE": article.title!,
            "DESCRIPTION": article.description!,
            "AUTHOR": 1,
            "CATEGORY_ID": 1,
            "STATUS": "true",
            "IMAGE": article.image!
        ]
        
        Alamofire.request("\(ARTICLE_URL)/\(article.id!)", method: .put, parameters: params, encoding: JSONEncoding.default, headers: HEADERS).responseJSON { (response) in
            if response.result.isSuccess {
                let json = try? JSON(data: response.data!)
                let message = json!["MESSAGE"].string
                self.delegate?.responseMessage(message: message!)
            }
        }
    }
    
    func uploadImage(data: Data, article: Article) {
        
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(data, withName: "FILE", fileName: ".jpg", mimeType: "image/*")
        }, to: UPLOAD_URL, method: .post, headers: HEADERS) { (result) in
            switch result {
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseJSON(completionHandler: { (response) in
                    let json = try? JSON(data: response.data!)
                    let imageUrl = json!["DATA"].string
                    article.image = imageUrl!
                    
                    if article.id == 0 {
                        self.insertArticle(article: article)
                    } else {
                        self.updateArticle(article: article)
                    }
                })
                
            case .failure(let error):
                print("ERROR UPLOAD:", error)
            }
        }
        
    }
    
}











