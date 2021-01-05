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
    var type: IngType.RawValue
    var amount: Double
    var measurement: String?
    var minimum: Double?
    

    init(name: String, type: IngType.RawValue, amount: Double, measurement: String?, minimum: Double?) {
        self.name = name
        self.type = type
        self.amount = amount
        self.measurement = measurement
        self.minimum = minimum
        
    }

}
