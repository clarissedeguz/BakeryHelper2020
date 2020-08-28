//
//  Ingredient.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-07-29.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation


class Ingredient {
    var name: String
    var amount: Int
    var measurement: String?
    var minimum: Int?
    

    init(name: String, amount: Int, measurement: String?, minimum: Int?) {
        self.name = name
        self.amount = amount
        self.measurement = measurement
        self.minimum = minimum
        
    }

}
