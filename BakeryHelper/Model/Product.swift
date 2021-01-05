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
    var wetIngItems: [String:[String: Double]]
    var dryIngItems: [String:[String: Double]]
    var serving: Double
    var price: Float
    
    init(name: String, wetIngItems: [String : [String: Double]], dryIngItems:[String:[String: Double]], serving: Double, price: Float) {
        self.name = name
        self.wetIngItems = wetIngItems
        self.dryIngItems = dryIngItems
        self.serving = serving
        self.price = price
    }
    
}
