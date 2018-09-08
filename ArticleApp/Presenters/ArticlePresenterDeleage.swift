//
//  ArticlePresenterDeleage.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 8/26/18.
//  Copyright © 2018 Chhaileng Peng. All rights reserved.
//

import Foundation

protocol ArticlePresenterDelegate {
    func responseArticles(articles: [Article])
    func responseMessage(messaeg: String)
}
