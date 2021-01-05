//
//  OrderFormCell.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-09-08.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell

protocol OrderFormDelegate {
    func stepperValueGrab(stepper: UIStepper, newValue: Double, at index: Int)
    func textFieldShouldEndEditing(text: String, textFieldTag: Int)

    
}

class OrderFormCell: UITableViewCell, UITextFieldDelegate  {
    
  
    var delegate: OrderFormDelegate?
    
    let textField: UITextField = {
        var tF = UITextField()
        tF.placeholder = "Enter Name"
        return tF
    }()

    
    let label: UILabel = {
        var label = UILabel(frame: CGRect(x: 250, y: 15, width: 50, height: 20))
        label.text = "0"
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(label)
        textField.delegate = self
        
    }
    
    @objc func tapDone() {
        if let datePicker = self.textField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            self.textField.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.textField.resignFirstResponder() // 2-5
    }
    
    let myUIStepper: UIStepper = {
        var stepper = UIStepper()
        stepper.frame = CGRect(x: 300, y: 8, width: 0, height: 0 )
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.minimumValue = 0
        stepper.maximumValue = 20
        return stepper
    }()
    
    @objc func stepperValueChanged(sender: UIStepper) {
           delegate?.stepperValueGrab(stepper: sender, newValue: sender.value, at: sender.tag)
           
           let displayVal = Int(sender.value)
           
           label.text = String(displayVal)
           
       }
     
      //MARK: - UITextField Delegate
        
        func setup(delegate: OrderFormDelegate) {
            textField.delegate = self
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


//MARK: - UIFoldingCell

 extension OrderFormCell {
   
   private func createForegroundView() -> RotatedView {
    let foregroundView: UIView = RotatedView(frame: CGRect(x: 65, y: 15, width: 85, height: 75))
    foregroundView.backgroundColor = .red
    foregroundView.translatesAutoresizingMaskIntoConstraints = false
    foregroundView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 8)
    foregroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8)
    let foregroundViewTop = foregroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
    foregroundViewTop.identifier = "foregroundViewTop"
    foregroundView.layoutIfNeeded()
    return foregroundView as! RotatedView
    
   }
   
    private func createContainerView() -> UIView {
        let containerView: UIView = UIView(frame: CGRect(x: 65, y: 15, width: 85, height: 456))
        containerView.backgroundColor = .green
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 8)
        containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8)
        
        let containerViewTop = containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 97)
        containerViewTop.identifier = "containerViewTop"
        containerView.layoutIfNeeded()
        return containerView
    }
    
    
}
    
    
    
    

    
  


