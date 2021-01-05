//
//  OrderSelCell.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-09-07.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit


class OrderSelCell: UICollectionViewCell {
    
    var label: UILabel = {
        var label = UILabel(frame: CGRect(x: 25, y: 65, width: 100, height: 100))
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected { // Selected cell
                self.backgroundColor = .red
            }
           }
        }
    }
    
    
    
    
    
    
    



