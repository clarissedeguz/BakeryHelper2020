//
//  ButtonCell.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-07-29.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit


protocol saveDataDelegate {
    func saveData()
}


class ButtonCell: UITableViewCell {
    var saveDataDG: saveDataDelegate?
    

    @IBAction func saveButton(_ sender: UIButton) {
        saveDataDG?.saveData()
        
    }
    
    
    
    
    
    
    
    
}
