//
//  ProductCell.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-08-08.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

class ProductCell: UICollectionViewCell {
    

    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: -10, y: 100, width: 150, height: 30))
        button.backgroundColor = .none
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
//        button.addTarget(self, action: #selector(addProduct), for: .touchUpInside)
        button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           
         addSubview(button)
           
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
    
    
    

