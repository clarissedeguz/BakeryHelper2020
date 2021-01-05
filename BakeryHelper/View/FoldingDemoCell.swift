//
//  FoldingCell.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-09-22.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell


class FoldingDemoCell: FoldingCell {
        
    @IBOutlet weak var label: UILabel!
    
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {

           // durations count equal containerView.subViews.count - 1
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
           return durations[itemIndex]
       }

    
    
    
    
    
    
    
    
    
}
