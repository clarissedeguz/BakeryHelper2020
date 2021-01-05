//
//  ProdFormViewController.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-08-10.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwipeCellKit

protocol ProductDelegate {
    
}

struct ingArrayName {
    var name: String
    var type: IngType
}

class ProdFormViewController: UITableViewController {
   
    var db: Firestore!
    var delegate: ProductDelegate?
    var ingType: IngType?
    var ingredientTypes: [IngType] = [.wetIngredient, .dryIngredient]
    var ingTypeResult = ""
    var resultString = ""
    var wetIng: [Ingredient] = []
    var dryIng: [Ingredient] = []
   
    fileprivate var formMod = FormModel()
    
    private var ingArray: [ingArrayName] = [ingArrayName(name: "Milk", type: .wetIngredient), ingArrayName(name: "Butter", type: .wetIngredient),ingArrayName(name: "Sugar", type: .dryIngredient)]
    
    let headerTitle: [String] = ["Name", "Serving", "Price","Ingredients", ""]
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ProdFormCell", for: indexPath) as! ProdFormCell
        cell.setup(delegate: self, pickerDelegate: self, pickerDataSource: self)
        cell.delegate = self
        cell.textFieldDelegate = self
        cell.prodForm.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
        cell.prodForm.textColor = UIColor(hexString: "80BB93", withAlpha: 1.0)
        
        cell.prodForm.text = headerTitle[indexPath.section]
       tableView.tableHeaderView?.frame = CGRect.zero
        
        cell.prodType.isHidden = true
        cell.prodMeas.isHidden = true
        
        
        
        switch indexPath.section {
        case 0 :
            cell.prodTextField.tag = indexPath.section
        case 1 :
            cell.prodTextField.tag = indexPath.section
        case 2:
            cell.prodTextField.placeholder = "$0.00"
            cell.prodTextField.tag = indexPath.section
        case 3:
            cell.prodForm.text! = ingArray[indexPath.row].name
            cell.prodForm.font = UIFont(name: "AvenirNextCondensed", size: 20)
            cell.prodForm.textColor = .flatBlack()
            cell.prodMeas.isHidden = false
            cell.thePicker.tag = indexPath.row
            cell.prodTextField.tag = indexPath.row + 30
            cell.prodMeas.tag = indexPath.row + 40
  
        case 4:
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
            return buttonCell
        default:
            print("We gucci")
        }
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3:
            return ingArray.count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let frame = tableView.frame

        switch section {
        case 3:
            let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            headerView.backgroundColor = .none
            let label = UILabel(frame: CGRect(x: 15, y: 25, width: 150, height: 25))
            label.text = headerTitle[section]
            label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
            label.textColor = UIColor(hexString: "80BB93", withAlpha: 1.0)
            
            
            headerView.addSubview(label)
            return headerView
        
        default:
            let headerView: UIView = UIView(frame: CGRect.zero)
            return headerView
        }
        
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.showsVerticalScrollIndicator = true
        
        db = Firestore.firestore()
        
    }
    
    @IBAction func addIng(_ sender: UIButton) {
        var ingTF = UITextField()
        let ingAlert = UIAlertController(title:  "New Ingredient", message: "", preferredStyle: .alert)
        
        ingAlert.addTextField { (ingTextField) in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            ingTF = ingTextField
            ingTF.attributedPlaceholder = NSAttributedString(string: "Enter Ingredient Name", attributes: [.paragraphStyle: paragraphStyle])
        }
       
        
        let dryIng = UIAlertAction(title: "Dry", style: .default) { (action) in
            let newIng = ingTF.text!
            let newItem = ingArrayName(name: newIng, type: .dryIngredient)
            self.ingArray.append(newItem)
            
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: self.ingArray.count - 1, section: 3)], with: .automatic)
                self.tableView.endUpdates()
            }
            
        }
        
        let wetIng = UIAlertAction(title:  "Wet" , style: .default) { (action) in
                  let newIng = ingTF.text!
                  let newItem = ingArrayName(name: newIng, type: .wetIngredient)
                  self.ingArray.append(newItem)
            
                  DispatchQueue.main.async {
                      self.tableView.beginUpdates()
                      self.tableView.insertRows(at: [IndexPath(row: self.ingArray.count - 1, section: 3)], with: .automatic)
                      self.tableView.endUpdates()
                  }
                  
              }
         
        ingAlert.addAction(wetIng)
        ingAlert.addAction(dryIng)
        present(ingAlert, animated: true, completion: nil)
       
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    var wetIngDic:[String: [String:Double]] = [:]
    var dryIngDic:[String: [String:Double]] = [:]
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        savingData()
        
        var ingName = ""
        var ingAmount: Double
        var ingMeas = ""
       
        let price = Float(formMod.price)
        
        for ingredient in wetIng {
            ingName = ingredient.name
            ingAmount = ingredient.amount
            ingMeas = ingredient.measurement ?? ""
            
          let dict = [ingMeas: ingAmount]
           wetIngDic[ingName] = dict
        }
      
        for ingredient in dryIng {
            ingName = ingredient.name
            ingAmount = ingredient.amount
            ingMeas = ingredient.measurement ?? ""
            
            let dict = [ingMeas: ingAmount]
            dryIngDic[ingName] = dict
        }
        
        addIngredient(price: price ?? 0)

        dismiss(animated: true)
    }
       
    func addIngredient(price: Float) {
        let dataToSave: [String: Any] = [
            "name": formMod.name,
            "serving": formMod.serving,
            "price": price,
            "wet ingredients": [wetIngDic],
            "dry ingredients": [dryIngDic]
        ]
        db.collection(ProdForm.dbName).addDocument(data: dataToSave) { (error) in
            if error != nil {
                print("Issue saving data to FireStore")
            } else {
                print("Successfully saved")
            }
        }
    }
    
    func savingData() {
        
        for key in formMod.prodIngArray {
            if key.type == IngType.wetIngredient.rawValue {
                wetIng.append(key)
            } else {
                dryIng.append(key)
            }
        }
        
    }
    
    
    
    
    
}
//MARK: - UIPickerView Delegate

extension ProdFormViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        ingType = ingArray[pickerView.tag].type
        return ingType?.content.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = .systemBlue
        pickerLabel.font = UIFont(name: "System", size: 30) // In this use your custom font
        
        pickerLabel.text = ingType?.content[row] ?? ""
        
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        resultString = ingType?.content[row] ?? ""
        
    }
}






//MARK: - UITextField Delegate

extension ProdFormViewController: ProdTextFieldDelegate {
    
    func textFieldShouldEndEditing(text: String, textFieldTag: Int) {
        switch textFieldTag {
        case 0:
            formMod.name = text
        case 1:
            formMod.serving = text
        case 2:
            formMod.price = text
        case 30...39:
            formMod.amount = text
        case 40...49:
            formMod.measurement = text
            
            if formMod.measurement.isEmpty {
                formMod.measurement = "N/A"
            }
            
            let index = textFieldTag-40
            
            let newIngredient = Ingredient(name: ingArray[index].name, type: ingArray[index].type.rawValue, amount: Double(formMod.amount) ?? 0, measurement: formMod.measurement, minimum: 0)
            self.formMod.prodIngArray.append(newIngredient)
            
        default:
            print("hi")
        }
    }
    
    func pickerViewTF(textField: UITextField) {
        textField.text = resultString
    }
}
//MARK: - SwipeTableViewCell Delegate

extension ProdFormViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.ingArray.remove(at: indexPath.row)
            self.formMod.prodIngArray.remove(at: indexPath.row)
            
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
            }
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
}

