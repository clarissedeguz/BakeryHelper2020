//
//  FormModel.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-08-28.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation

 struct FormModel {
    var name: String = ""
    var amount: String = ""
    var type: String = ""
    var measurement: String = ""
    var notif: String = ""
    var serving: String = ""
    var date: String = ""
    var price: String = ""
    var prodIngArray: [Ingredient] = []
}
