//
//  ProdFormCell.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-08-12.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit
import SwipeCellKit


protocol ProdTextFieldDelegate {
    func textFieldShouldEndEditing(text: String, textFieldTag: Int)
    func pickerViewTF(textField: UITextField)
}

class ProdFormCell: SwipeTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var prodForm: UILabel!
    @IBOutlet weak var prodTextField: UITextField!
    @IBOutlet weak var prodMeas: UITextField!
    @IBOutlet weak var prodType: UITextField!
    
    var textFieldDelegate: ProdTextFieldDelegate?
    let thePicker = UIPickerView()
    
    func textFieldUI(textField: UITextField) {
          let bottomLine = CALayer()
          bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2 , width: textField.frame.width, height: 2)
          bottomLine.backgroundColor = UIColor(hexString: "80BB93", withAlpha: 1)?.cgColor
          textField.borderStyle = .none
          textField.layer.addSublayer(bottomLine)
      }
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldUI(textField: prodType)
        textFieldUI(textField: prodMeas)
        textFieldUI(textField: prodTextField)
    }

    //MARK: - UITextField Delegate
    func setup(delegate: ProdTextFieldDelegate, pickerDelegate: UIPickerViewDelegate, pickerDataSource:UIPickerViewDataSource) {
        prodTextField.delegate = self
        prodType.delegate = self
        prodMeas.delegate = self
        prodMeas.autocorrectionType = .no
        self.textFieldDelegate = delegate
        thePicker.delegate = pickerDelegate
        thePicker.dataSource = pickerDataSource
        prodMeas.inputView = thePicker
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textFieldDelegate?.textFieldShouldEndEditing(text: textField.text ?? "N/A", textFieldTag: textField.tag)
        textFieldDelegate?.pickerViewTF(textField: prodMeas)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    
}
    
  
