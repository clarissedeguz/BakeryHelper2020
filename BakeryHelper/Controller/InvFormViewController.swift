//
//  TableViewController.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-07-29.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol InventoryDelegate {
}
class InvFormViewController: UITableViewController {
    
    var db: Firestore!
    var delegate: InventoryDelegate?
    var docRef: DocumentReference!
    var formMod = FormModel()
    var ingredientType: IngType?
    var ingredientTypes: [IngType] = [.wetIngredient, .dryIngredient]
    var pickerResult =  ""
    var resultString = ""
    
    @IBAction func Save(_ sender: UIBarButtonItem) {
        addIngredient()
        dismiss(animated: true)        
    }
    @IBAction func Back(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FormCell", for: indexPath) as! FormCell
        cell.setup(delegate: self, pickerDelegate: self, pickerDatasource: self)
        switch indexPath.row {
        case 0 :
            cell.formLabel.text! = "Name"
            cell.formTextField.placeholder = "Enter Item Name"
            cell.measTextField.placeholder = "Type"
            cell.measTextField.tag = indexPath.row + 5
            cell.formTextField.tag = indexPath.row
            cell.typePicker.tag = indexPath.row
        case 1 :
            cell.formLabel.text! = "Amount"
            cell.formTextField.tag = indexPath.row
            cell.measTextField.tag = indexPath.row + 10
            cell.formTextField.placeholder = "Enter Amount"
            cell.measTextField.placeholder = "g"
            cell.typePicker.tag = indexPath.row
        default:
            cell.formLabel.text! = "Notify me when it reaches this amount:"
            cell.formTextField.tag = indexPath.row //2
            cell.formTextField.placeholder = "Enter Amount Min."
            cell.measTextField.isHidden = true
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 85
        tableView.reloadData()
        tableView.separatorStyle = .none
        db = Firestore.firestore()
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = tableView.frame
        switch section {
        case 0:
            let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            headerView.backgroundColor = .none
            return headerView
        default:
            let headerView: UIView = UIView(frame: CGRect.zero)
            return headerView
        }
    }
    func addIngredient() {
        print(formMod.prodIngArray.count)
        let dataToSave: [String: Any] = ["name": formMod.prodIngArray[0].name, "type": formMod.prodIngArray[0].type, "amount": formMod.prodIngArray[0].amount,  "measurement": formMod.prodIngArray[0].measurement ?? 0, "notifValue": formMod.prodIngArray[0].minimum ?? 0]
        db.collection(InvForm.dbName).addDocument(data: dataToSave) { (error) in
            if error != nil {
                print("Issue saving data to FireStore")
            } else {
                print("Successfully saved")
                print(dataToSave)
            }
        }
    }

}

//MARK: - UIPickerViewDelegate
extension InvFormViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return ingredientTypes.count
        } else {
            return ingredientType?.content.count ?? 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = .systemBlue
        pickerLabel.font = UIFont(name: "System", size: 30) // In this use your custom font
        
        if pickerView.tag == 0 {
            pickerLabel.text = ingredientTypes[row].rawValue
        } else {
            pickerLabel.text = ingredientType?.content[row] ?? ""
        }
        
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            ingredientType = ingredientTypes[row]
            pickerResult =  ingredientType?.rawValue ?? ""
        } else if pickerView.tag == 1 {
            resultString = ingredientType?.content[row] ?? ""
        }
    }
}
//MARK: - TextField Delegate

extension InvFormViewController: TextFieldDataDelegate {
    
    func textFieldShouldEndEditing(text: String, textFieldTag: Int) {
        switch textFieldTag {
        case 0:
            formMod.name = text
            print("name: \(formMod.name)")
        case 1:
            formMod.amount = text
            print("amount: \(formMod.amount)")
        case 2:
            formMod.notif = text
            print("notif: \(formMod.notif)")
        case 5:
            formMod.type = text
            print("type: \(formMod.type)")
        case 11:
            formMod.measurement = text
            print("measurement: \(formMod.measurement)")
        default:
            print("we gucci")
        }
        if !formMod.name.isEmpty, !formMod.amount.isEmpty, !formMod.notif.isEmpty {
            let newItem = Ingredient(name: formMod.name, type: formMod.type, amount: Double(formMod.amount) ?? 0, measurement: formMod.measurement, minimum: Double(formMod.notif) ?? 0)
            formMod.prodIngArray.append(newItem)
            print("TFShouldEndEditing(): \(formMod.prodIngArray.count)")
        }
    }
    func pickerTextFieldShouldShow(textField: UITextField, textFieldTag: Int){
        if textFieldTag == 5 {
            textField.text = pickerResult
            formMod.type = textField.text ?? ""
        } else if textFieldTag == 11 {
            textField.text = resultString
            formMod.measurement = textField.text ?? ""
        }
    }
    
}



