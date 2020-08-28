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


protocol ProductDetailDelegate: class {
    func getData() -> [Product]
}




class ProdDetailViewController: UITableViewController {
    
    private var prodToDisp: [Product] = []
    private var prodIngDict: [String:[String: Int]] = [:]
    private var prodIng: [IngDisp] = []
    weak var delegate: ProductDetailDelegate?
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProdDetail", for: indexPath) as! ProdDetailCell
        
        switch indexPath.section {
            
        case 0:
            cell.label.text = "PRODUCT NAME:"
   
            cell.amount.text = prodToDisp[indexPath.row].name
        case 1:
            cell.label.text = "SERVING SIZE:"
            cell.amount.text = String(prodToDisp[indexPath.row].serving)
        case 2:
            cell.label.text = prodIng[indexPath.row].name
            
            if prodIng[indexPath.row].measurement == "N/A" {
                cell.amount.text = (prodIng[indexPath.row].amount)
            } else {
                cell.amount.text = ("\(prodIng[indexPath.row].amount) \(prodIng[indexPath.row].measurement)")
            }
            
        default:
            print("another typa cell")
        
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            
            return prodIngDict.count
            
        }
    
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
           return 3
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
    
    
    func getDisplayData() {
        prodToDisp = delegate?.getData() as! [Product]
        prodIngDict = prodToDisp[0].ingItems
        
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
        
    
        print(prodIng.count)
      
        for key in prodIngDict.keys {
            prodIngDict[key.uppercased()] = prodIngDict.removeValue(forKey: key)
        }
        
        
        
        
        print("2PRODVC getDisplDat() TO DISPLAY: \(prodToDisp[0].name)")
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        getDisplayData()
      
        
        
    }
    
   
    
    
    
}
