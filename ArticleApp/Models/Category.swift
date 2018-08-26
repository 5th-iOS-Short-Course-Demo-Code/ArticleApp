//
//  Category.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 8/26/18.
//  Copyright © 2018 Chhaileng Peng. All rights reserved.
//

import Foundation
import SwiftyJSON

class Category {
    var id: Int?
    var name: String?
    
    init() { }
    
    init(json: JSON) {
        self.id = json["ID"].int
        self.name = json["NAME"].string
    }
}
