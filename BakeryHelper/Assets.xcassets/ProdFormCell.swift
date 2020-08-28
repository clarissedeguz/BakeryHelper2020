//
//  ProdFormCell.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-08-12.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit


protocol ProdTextFieldDelegate {
    func textFieldShouldEndEditing(text: String, textFieldTag: Int)
    
}


class ProdFormCell: UITableViewCell, UITextFieldDelegate {
//
//    @IBOutlet weak var prodPV: UIPickerView!
//
    @IBOutlet weak var prodForm: UILabel!
    
    @IBOutlet weak var prodTextField: UITextField!
    
    @IBOutlet weak var prodMeas: UITextField!
    
    
    var delegate: ProdTextFieldDelegate?
    
    let measurements = ["g" , "kg", "tbsp", "tsp", "cups", "ml" , "l"]
    

    let thePicker = UIPickerView()


    

    
    override func awakeFromNib() {
        thePicker.delegate = self
        thePicker.dataSource = self
        prodMeas.inputView = thePicker
      
        prodTextField.autocorrectionType = .no      
    }
    
    //MARK: - UITextField Delegate
    
    func setup(delegate: ProdTextFieldDelegate) {
        prodTextField.delegate = self
        prodMeas.delegate = self
        self.delegate = delegate
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        
        delegate?.textFieldShouldEndEditing(text: textField.text ?? "N/A", textFieldTag: textField.tag)
        
        
        
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    

}
    
    //MARK: - UIPickerViewDelegate
    
extension ProdFormCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return measurements.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return measurements[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = .systemBlue
        pickerLabel.text = measurements[row]
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "System", size: 30) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        prodMeas.text = measurements[row]
    }
}








