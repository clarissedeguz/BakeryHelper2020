//
//  ProdDetailViewController.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-08-17.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwipeCellKit


protocol ProductDetailDelegate: class {
    func getData() -> [Product]
}


class ProdDetailViewController: UITableViewController {
    
    private var prodToDisp: [Product] = []
    private var prodIngDict: [String:[String: Double]] = [:]
    private var prodIng: [IngDisp] = []
    weak var delegate: ProductDetailDelegate?
    var db: Firestore!
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProdDetail", for: indexPath) as! ProdDetailCell
        
        switch indexPath.section {
        case 0:
            cell.label.text = "Product:"
            cell.amount.text = prodToDisp[indexPath.row].name
        case 1:
            cell.label.text = "Serving Size:"
            cell.amount.text = String(prodToDisp[indexPath.row].serving)
        case 2:
            cell.label.text = "Price"
            cell.amount.text = "$\(String(prodToDisp[indexPath.row].price))"
        case 3:
            cell.label.text = prodIng[indexPath.row].name
            
            switch prodIng[indexPath.row].measurement {
            case "N/A":
                cell.amount.text = (prodIng[indexPath.row].amount)
            default:
                cell.amount.text = ("\(prodIng[indexPath.row].amount) \(prodIng[indexPath.row].measurement)")
            }
            
        default:
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
            return buttonCell
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 3 {
            return prodIng.count
        }
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = ["Name", "Serving", "Price", "Ingredients", ""]
        return title[section]
    }
    
    
    @IBAction func deleteRec(_ sender: UIButton) {
        
       let recToDelete = prodToDisp[0].name
              db.collection(ProdForm.dbName).whereField("name", isEqualTo: recToDelete)
                  .getDocuments() { (querySnapshot, err) in
                      if let err = err {
                          print("Error getting documents: \(err)")
                      } else {
                          for document in querySnapshot!.documents {
                              self.db.collection(ProdForm.dbName).document(document.documentID).delete()
                          }
                        
                        DispatchQueue.main.async {
                            self.dismiss(animated: true)
                        }
                     
                    }
              }
       
        
        
        }
    
    
    
    func getDisplayData() {
        if let data = delegate?.getData() as? [Product] {
            prodToDisp = data
            let wetIng = prodToDisp[0].wetIngItems
            let dryIng = prodToDisp[0].dryIngItems
            
            var combinedAttributes : NSMutableDictionary!

            combinedAttributes = NSMutableDictionary(dictionary: wetIng)

            combinedAttributes.addEntries(from: dryIng)
            
            prodIngDict = combinedAttributes as! [String : [String : Double]]
            
            for (key, value) in prodIngDict {
                let name = key
                var amount: String = ""
                var measurement: String = ""
                
                for (key, values) in value {
                    amount = String(values)
                    measurement = key
                }
                let newItem = IngDisp(name: name, amount: amount, measurement: measurement)
                self.prodIng.append(newItem)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        getDisplayData()
        db = Firestore.firestore()
        
        
        
    }
    

}


