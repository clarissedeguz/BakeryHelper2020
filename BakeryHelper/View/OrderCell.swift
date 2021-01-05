//
//  OrderCell.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-09-16.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit

class OrderCell: UICollectionViewCell {
    
    var label: UILabel = {
        var label = UILabel(frame: CGRect(x: 185 , y: 0, width: 200, height: 45))
        label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "80BB93", withAlpha: 1)
        return label
    }()
    
    var total: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 145))
        label.textColor = .white
        label.backgroundColor = UIColor(hexString: "A94C4C", withAlpha: 0.6)
        label.textAlignment = .center
       
        label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 35)
        
        return label
    }()
    
    var order: UILabel = {
        var label = UILabel(frame: CGRect (x: 185, y: 35, width: 200, height: 105))
        label.textColor = .darkGray
        label.text = "order"
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Bold", size: 15)
        label.numberOfLines = 0
        return label
    }()
    var name: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: -15, width: 150, height: 80))
        label.textColor = .white
        label.text = "name"
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)
        
        return label
    }()
    
    var status: UILabel = {
      var label = UILabel(frame: CGRect(x: 0, y: 50, width: 150, height: 145))
         label.textColor = .white
         label.textAlignment = .center
         label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 15)
         
         return label
       
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(total)
        addSubview(order)
        addSubview(name)
        addSubview(label)
        addSubview(status)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}
