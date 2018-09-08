//
//  ArticleService.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 8/26/18.
//  Copyright © 2018 Chhaileng Peng. All rights reserved.
//

import Foundation
import SwiftyJSON

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












