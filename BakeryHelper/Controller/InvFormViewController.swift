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
    
    var items: [Ingredient] = []
    var db: Firestore!
    
    var delegate: InventoryDelegate?
    var docRef: DocumentReference!
    
    var nameInfo: String = ""
    var amntInfo: String = ""
    var notifInfo: String = ""
    
    
    
    @IBAction func Save(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
        
    }
    
    
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FormCell", for: indexPath) as! FormCell
        cell.tag = indexPath.row
        
        cell.setup(delegate: self)
        
        switch indexPath.row {
        case 0 : cell.formLabel.text! = "Name"
        case 1 : cell.formLabel.text! = "Amount"
        default: cell.formLabel.text! = "Notify Me When"
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
        tableView.rowHeight = 100
        tableView.reloadData()
        db = Firestore.firestore()
        
        
        
    }
    
    
    func addIngredient(name: String, amnt: String, minimum: String) {
      
        let dataToSave: [String: Any] = ["name": name, "amount": amnt, "notifValue": minimum]
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

//MARK: - TextField Delegate

extension InvFormViewController: TextFieldDataDelegate {
    
    func textFieldShouldEndEditing(text: String, celltag: Int) {
        
        if celltag == 0 {
            nameInfo = text
        } else if celltag == 1 {
            amntInfo = text
            
        } else if celltag == 2 {
            notifInfo = text
            
        }
        
        if !nameInfo.isEmpty, !amntInfo.isEmpty, !notifInfo.isEmpty {
            addIngredient(name: nameInfo, amnt: amntInfo, minimum: notifInfo)
        }
        
    }
    
}



