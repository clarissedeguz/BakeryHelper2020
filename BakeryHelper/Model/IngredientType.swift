//
//  IngredientType.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-10-13.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation

enum IngredientType: String {
    case wetIngredient = "Wet Ingredient"
    case dryIngredient = "Dry Ingredient"
    
    var content: [String] {
        switch self {
        case .wetIngredient:
            return ["l", "ml", "cups", "tbsp", "tsp"]
        case .dryIngredient:
            return ["g", "kg", "lb", "oz"]
        }
    }
}
