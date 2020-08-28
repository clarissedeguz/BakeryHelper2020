//
//  Product.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-07-29.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation


class Product {
    var name: String
    var ingItems: [String:[String: Int]]
    var serving: Int
    
    init(name: String, ingItems: [String : [String: Int]],serving: Int) {
        self.name = name
        self.ingItems = ingItems
        self.serving = serving
    }
    
}
