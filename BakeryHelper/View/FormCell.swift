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
    func textFieldShouldEndEditing(text: String, textFieldTag: Int)
    func pickerTextFieldShouldShow(textField: UITextField, textFieldTag: Int)
}
class FormCell: UITableViewCell, UITextFieldDelegate {

    var pickerDatasource: UIPickerViewDataSource?
    var pickerDelegate: UIPickerViewDelegate?
    
    var delegate: TextFieldDataDelegate?
    let typePicker = UIPickerView()
    
    
    //VC does not have to know that cell has a delegate inside it, but has to know that there's a function that helps it
    func setup(delegate: TextFieldDataDelegate, pickerDelegate: UIPickerViewDelegate, pickerDatasource: UIPickerViewDataSource) {
        formTextField.delegate = self
        measTextField.delegate = self
        measTextField.autocorrectionType = .no
        self.delegate = delegate
        typePicker.delegate = pickerDelegate
        typePicker.dataSource = pickerDatasource
        typePicker.tag = 0
        measTextField.inputView = typePicker // VERY MUCH IDIOT
    }
    
    @IBOutlet weak var formLabel: UILabel!
    @IBOutlet weak var formTextField: UITextField!
    @IBOutlet weak var measTextField: UITextField!
    
    func textFieldUI(textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2 , width: textField.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor(hexString: "80BB93", withAlpha: 1)?.cgColor
        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
    }
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        formLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
        formLabel.textColor = UIColor(hexString: "80BB93", withAlpha: 1)
        textFieldUI(textField: measTextField)
        textFieldUI(textField: formTextField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldEndEditing(text: textField.text ?? "N/A", textFieldTag:textField.tag)
        delegate?.pickerTextFieldShouldShow(textField: measTextField, textFieldTag: textField.tag)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    

}

