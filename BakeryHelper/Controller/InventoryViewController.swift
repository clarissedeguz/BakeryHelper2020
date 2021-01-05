//
//  InventoryViewController.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-07-29.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwipeCellKit

class InventoryViewController: UITableViewController, InventoryDelegate {
    var db: Firestore!
    var docRef: DocumentReference!
    private var itemArray: [Ingredient] = []
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.delegate = self
        cell.amount.text = "\(String(itemArray[indexPath.row].amount)) \(itemArray[indexPath.row].measurement ?? "N/A")"
        cell.title.text = itemArray[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        db = Firestore.firestore()
    }
    override func viewWillAppear(_ animated: Bool) {
        let navBar = navigationController?.navigationBar
        navBar?.tintColor = UIColor(red: 255/255, green: 154/255, blue: 118/255, alpha: 0.5)
    }
    override func viewDidAppear(_ animated: Bool) {
        getIngredients()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToForm" {
            if let nextViewController = segue.destination as? UINavigationController {
                if let vc = nextViewController.viewControllers.first as? InvFormViewController {
                    vc.delegate = self
                }
            }
        }
    }
    func getIngredients() {
        db.collection(InvForm.dbName).order(by: "name").addSnapshotListener() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.itemArray = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let dataAmnt = data["amount"] as? Double, let dataMin = data["notifValue"] as? Double {
                        let item = Ingredient(name: data["name"] as! String, type: data["type"] as? String ?? "N/A", amount: dataAmnt , measurement: data["measurement"] as? String ?? "N/A" , minimum: dataMin)
                        self.itemArray.append(item)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                self.checkForAmnt()
            }
        }
    }
    func checkForAmnt() {
        var restockNeeded: [String] = []
        for item in itemArray {
            let itemAmnt = item.amount
            let itemMin = item.minimum
            let itemName = item.name

            if itemAmnt <= itemMin ?? 0 {
                restockNeeded.append(itemName)
            }
        }
        
        if restockNeeded.count >= 1 {
            let ingAlert = UIAlertController(title:  "RESTOCK ON INGREDIENTS", message: "\(restockNeeded.joined(separator: "\n"))", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            
            ingAlert.addAction(action)
            present(ingAlert, animated: true, completion: nil)
        }
        
    }

    func deleteIngredient(at indexPath: IndexPath) {
        let ingToDelete = self.itemArray[indexPath.row]
        db.collection(InvForm.dbName).whereField("name", isEqualTo: ingToDelete.name)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.db.collection(InvForm.dbName).document(document.documentID).delete()
                    }
                }
        }
    }
}
//MARK: - SwipeTableViewCell Delegate

extension InventoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.deleteIngredient(at: indexPath)
            self.itemArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
}

