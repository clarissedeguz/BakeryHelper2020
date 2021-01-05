//
//  Order2ViewController.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-09-22.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell


class Order2ViewController: UITableViewController {
    
    let kCloseCellHeight: CGFloat = 75 // equal or greater foregroundView height
    let kOpenCellHeight: CGFloat = 456 // equal or greater containerView height
    let kRowsCount = 6
    
     var cellHeights: [CGFloat] = []
    
        override func viewDidLoad() {
           super.viewDidLoad()

           cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
           tableView.estimatedRowHeight = kCloseCellHeight
           tableView.rowHeight = UITableView.automaticDimension
             tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
                   }
               
               
               // MARK: Actions
               @objc func refreshHandler() {
                   let deadlineTime = DispatchTime.now() + .seconds(1)
                   DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
                       if #available(iOS 10.0, *) {
                           self?.tableView.refreshControl?.endRefreshing()
                       }
                       self?.tableView.reloadData()
                   })
               }
           
       
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingDemoCell
           let durations: [TimeInterval] = [0.26, 0.2, 0.2]
           cell.durationsForExpandedState = durations
           cell.durationsForCollapsedState = durations
            
        
           return cell
       }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingDemoCell

                 var duration = 0.0
                 if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
                     cellHeights[indexPath.row] = kOpenCellHeight
                    cell.setSelected(true, animated: true)
                     duration = 0.5
                 } else {// close cell
                     cellHeights[indexPath.row] = kCloseCellHeight
                    cell.setSelected(false, animated: true)
                     duration = 1.1
                 }

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                     tableView.beginUpdates()
                     tableView.endUpdates()
                 }, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is FoldingDemoCell {
                   let foldingCell = cell as! FoldingDemoCell

                   if cellHeights[indexPath.row] == kCloseCellHeight {
                       foldingCell.setSelected(false, animated: false)
                    
                    
                    
                   } else {
                    foldingCell.setSelected(true, animated: false)
                    cell.contentView.subviews[1].backgroundColor = .black
                   }
               }
           }

}
