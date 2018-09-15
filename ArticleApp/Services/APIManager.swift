//
//  APIManager.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 9/15/18.
//  Copyright © 2018 Chhaileng Peng. All rights reserved.
//

import Foundation

class APIManager {
    
    static let BASE_URL = "http://35.240.238.182:8080"
    
    static let ARTICLE_URL = "\(BASE_URL)/v1/api/articles"
    static let UPLOAD_URL = "\(BASE_URL)/v1/api/uploadfile/single"
    
    static let HEADERS = [
        "Authorization": "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=",
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    
    
}
