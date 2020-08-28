//
//  FormViewController.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-07-29.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit

protocol TextFieldDataDelegate {
    func textFieldShouldEndEditing(text: String, celltag: Int)
    
}

class FormCell: UITableViewCell, UITextFieldDelegate{
    
    var delegate: TextFieldDataDelegate?
    var item: Ingredient?
    
    
    //VC does not have to know that cel has a delegate inside it, but has to know that there's a function that helps i
    func setup(delegate: TextFieldDataDelegate) {
        formTextField.delegate = self
        self.delegate = delegate
    }
    
    
    @IBOutlet weak var formLabel: UILabel!
    
    @IBOutlet weak var formTextField: UITextField!
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        delegate?.textFieldShouldEndEditing(text: textField.text ?? "N/A", celltag:tag)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    

}


