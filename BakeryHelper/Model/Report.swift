//
//  Report.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-07-29.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation


class Report {
    var orders: [Order]
    var total: Int
    var date: Date
    
    init(orders: [Order], total: Int, date: Date) {
        self.orders = orders
        self.total = total
        self.date = date
    }
}
