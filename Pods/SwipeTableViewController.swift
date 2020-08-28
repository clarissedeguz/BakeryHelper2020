//
//  SwipeTableViewController.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-08-03.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import SwipeCellKit
import UIKit

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {
    

    
    var cell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
    }
    
    //TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
            tableView.reloadData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func updateModel(at indexPath: IndexPath) {
        //Update our DataModel
    }
    
    
    
    
    
    
    
    
    
}
