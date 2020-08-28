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

protocol ProductDelegate {
    
}

class ProdFormViewController: UITableViewController {
    
    var db: Firestore!
    var delegate: ProductDelegate?
   
    private var prodIngArray: [Ingredient] = []
    private var ingArray = ["Milk", "Butter", "Sugar"]
    private var prodIngDic: [String: [String: Int]] = [:]
  
    fileprivate var newIng: String = ""
   
    fileprivate var name: String = ""
    fileprivate var serving: String = ""
    fileprivate var amount: String = ""
    fileprivate var measurement: String = ""

   
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ProdFormCell", for: indexPath) as! ProdFormCell
        cell.setup(delegate: self)
        
        switch indexPath.section {
        case 0 : cell.prodForm.text! = "Name"
        cell.prodTextField.tag = 10
        cell.prodMeas.isHidden = true
        case 1 : cell.prodForm.text! = "Serving"
        cell.prodTextField.tag = 20
        cell.prodMeas.isHidden = true
        case 2:
            cell.prodForm.text! = ingArray[indexPath.row]
            cell.prodTextField.tag = indexPath.row + 30
            cell.prodMeas.tag = indexPath.row + 40
        case 3:
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
            return buttonCell
        default:
            print("We gucci")
        }
        
        
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfRow: Int
        
        switch section {
        case 0: numOfRow = 1
        case 1: numOfRow = 1
        case 2: numOfRow = ingArray.count
        default: numOfRow = 1
        }
        
        return numOfRow
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var header: String = ""
        
        switch section {
        case 0: header = "NAME"
        case 1: header = "SERVING"
        case 2: header  = "INGREDIENTS"
        default: return nil
        }
        return header
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
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
       
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.newIng = ingTF.text!
            self.ingArray.append(self.newIng)
            
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: self.ingArray.count - 1, section: 2)], with: .automatic)
                self.tableView.endUpdates()
            }
            
        }
        
       ingAlert.addAction(action)
        present(ingAlert, animated: true, completion: nil)
       
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        var ingName = ""
        var ingAmount = 0
        var ingMeas = ""
        
        for ingredient in prodIngArray {
            ingName = ingredient.name
            ingAmount = ingredient.amount
            ingMeas = ingredient.measurement ?? ""
            
            prodIngDic[ingName] = [ingMeas: ingAmount]
        }
        
        print("SAVE: \(prodIngDic)")
        
        addIngredient(name: name, serving: Int(serving) ?? 0, ingName: "test", ingAmnt: prodIngDic)
        
//        dismiss(animated: true)
        
        
    }
       
    
    
    
    func addIngredient(name: String, serving: Int, ingName: String, ingAmnt: [String: [String: Int]]) {
    
        let dataToSave: [String: Any] = [
            "name": name,
            "serving": serving,
            "ingredients": [ingAmnt]
            ]
        
        db.collection(ProdForm.dbName).addDocument(data: dataToSave) { (error) in
            if error != nil {
                print("Issue saving data to FireStore")
            } else {
                print("Successfully saved")
                print(dataToSave)
            }
        }
        
        
        
    }
        
    }
    
    
    




//MARK: - UITextField Delegate

extension ProdFormViewController: ProdTextFieldDelegate {
    
    func textFieldShouldEndEditing(text: String, textFieldTag: Int) {
        switch textFieldTag {
        case 10:
            name = text
        case 20:
            serving = text
        case 30...39:
            amount = text
        case 40...49:
            measurement = text
            
            let index = textFieldTag-40
            
            let newIngredient = Ingredient(name: ingArray[index], amount: Int(amount) ?? 0, measurement: measurement, minimum: 0)
            self.prodIngArray.append(newIngredient)

        default:
        print("hi")
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        switch celltag {
//        case 10:
//            print(name)
//            name = text
//        case 20:
//            serving = text
//        case 0:
//            if textFieldTag == 30 {
//                mAmount = text
//            } else if textFieldTag == 40 {
//                mMeasurement = text
//            }
//            if !mAmount.isEmpty && !mMeasurement.isEmpty {
//                let milk = Ingredient(name: "Milk", amount: Int(mAmount) ?? 0, measurement: mMeasurement, minimum: 0)
//                self.prodIngArray.append(milk)
//            }
//        case 1:
//            if textFieldTag == 31 {
//                bAmount = text
//            } else if textFieldTag == 41  {
//                bMeasurement = text
//            }
//            if !bAmount.isEmpty && !bMeasurement.isEmpty {
//                let butter = Ingredient(name: "Butter", amount: Int(bAmount) ?? 0, measurement: bMeasurement, minimum: 0)
//                self.prodIngArray.append(butter)
//            }
//        case 2:
//            if textFieldTag == 32 {
//                sAmount = text
//
//            } else if textFieldTag == 42 {
//                sMeasurement = text
//
//            }
//            if !sAmount.isEmpty && !sMeasurement.isEmpty {
//                let sugar = Ingredient(name: "Sugar", amount: Int(sAmount) ?? 0, measurement: sMeasurement, minimum: 0)
//                self.prodIngArray.append(sugar)
//            }
//        default:
//
//            if textFieldTag == celltag + 30 {
//                amount = ""
//                amount = text
//                print("TFShouldEndEditing() Amount: \(amount), \(newIng) TF\(textFieldTag)")
//            }
//            if textFieldTag == celltag + 40 {
//                measurement = ""
//                measurement = text
//                print("TFShouldEndEditing() Measurement: \(measurement), \(newIng) TF\(textFieldTag)")
//
//                print(amount, newIng, measurement)
//
//                if measurement.isEmpty {
//                    measurement = "N/A"
//                }
//
//                let newIngredient = Ingredient(name: newIng, amount: Int(amount) ?? 0, measurement: measurement, minimum: 0)
//                self.prodIngArray.append(newIngredient)
//
//
//            }
//
//        }
//
//
//    }
    
}
}
