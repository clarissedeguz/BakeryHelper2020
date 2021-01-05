//
//  OrderViewController.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-09-06.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit


//Where order data gets reloaded and shown
class OrderViewController: ProductGrid {
    
    var allOrders: [Order] = []
    var selectedCell = [IndexPath]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(OrderCell.self, forCellWithReuseIdentifier: "myCell")
        getIngredients(databaseCollection: OrderForm.dbName)
        collectionView.allowsMultipleSelection = true
        collectionView.allowsSelection = true
        collectionView.clipsToBounds = false
    }
    
    
   override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let spaceBetweenCells = 5
           let width = (Int(self.collectionView.frame.size.width) - spaceBetweenCells * 2)
           let height = (Int(self.collectionView.frame.size.height) - spaceBetweenCells * 3)/6
           
           return CGSize(width: width, height: height)
       }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: -5, left: 0, bottom: 10, right: 0)
     }
    
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return allOrders.count
       }
    
   func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! OrderCell
        cell.backgroundColor = .white
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatter.string(from: allOrders[indexPath.row].deadline)
        
        let attributedString = NSMutableAttributedString.init(string: date)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
            NSRange.init(location: 0, length: attributedString.length));
        
        cell.label.attributedText = attributedString
        cell.name.text = allOrders[indexPath.row].name
        
        
        if allOrders[indexPath.row].isDelivered == true {
            cell.total.backgroundColor = UIColor(hexString: "80BB93", withAlpha: 0.6)
        } else {
            cell.total.backgroundColor = UIColor(hexString: "A94C4C", withAlpha: 0.6)
//            print("45")
        }
        
        cell.status.text = "In Progress"

        var order = ""
        for orders in allOrders[indexPath.row].order{
            let ok = orders.name
            let ov = String(format: "%0.0f", orders.serving)
            order += ("\(ok)(\(ov)) \n")
        }
        cell.order.text = order
        
        cell.total.text = "$\(String(format: "%0.2f",allOrders[indexPath.row].price))"
        
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 0.2
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? OrderCell
        if cell?.isSelected == true{
            cell?.total.backgroundColor = UIColor(hexString: "80BB93", withAlpha: 0.6)
            allOrders[indexPath.row].isDelivered = true
//            print( allOrders[indexPath.row].isDelivered, allOrders[indexPath.row].name)
            cell?.status.text = "Delivered"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
         let cell = collectionView.cellForItem(at: indexPath) as? OrderCell
               if cell?.isSelected == false{
                allOrders[indexPath.row].isDelivered = false
                cell?.total.backgroundColor = UIColor(hexString: "A94C4C", withAlpha: 0.6)
                cell?.status.text = "In Progress"
                  }
    }

    

    
    
    
    
  override func getIngredients(databaseCollection: String ) {
           // [START get_document]
//           print("WORKING")
           
           
           db.collection(databaseCollection).order(by: "name").addSnapshotListener() { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                
                   self.allOrders = []
                   
                   for document in querySnapshot!.documents {
                       
                       let data = document.data()
                       
                       
                    if let dataName = data["name"] as? String, let dataDate = data["date"] as? String, let products = data["products"] as? [String: Any] {
                   
                        let today = Date()
                        let formatter4 = DateFormatter()
                        formatter4.dateFormat = "MMM dd, yyyy"
                        let newDate = formatter4.date(from: dataDate)
                      
                        var prodName: String = ""
                        var productOrders : [Product] = []
                        
                        for product in products {
                          prodName = product.key
                            if let prodValue =  product.value as? [String: Any] {
                                
                                var wetValue: [String: [String: Double]]? = [:]
                                var dryValue: [String: [String: Double]]? = [:]
                                var price: Float = 0.00
                                var servingDisplay: Double = 0.00
                                
                                for (key, value) in prodValue {
                                    
                                    switch key {
                                    case "dry ingredients": dryValue = value as? [String: [String: Double]]
                                    case "wet ingredients": wetValue = value as? [String: [String: Double]]
                                    case "price": price = value as? Float ?? 0
                                    case "servingDisp": servingDisplay = value as? Double ?? 0
                                    default: print("")
                                    }
                                }
                                
                                
                                let newItem = Product(name: prodName, wetIngItems: wetValue ?? [:], dryIngItems: dryValue ?? [:], serving: servingDisplay , price: price)
                             
                                productOrders.append(newItem)
//                                print(newItem.name, newItem.ingItems, newItem.serving, newItem.price)
        
                            }
                            
                        }
                       
                        var valueArr: [Float] = []
                        for product in productOrders {
                            let value = product.price
                            valueArr.append(value)
//                            print(valueArr.count)
                            
                        }
                        
                        var counter = 0
                        var sum: Float = 0.0
                        
                        while counter < valueArr.count {
                            for index in valueArr {
                                sum += index
//                                print("sum: \(sum)")
                                counter += 1
                            }
                            
                        }
                        
                        
                        let newOrder = Order(name: dataName, due: newDate ?? today, price: sum, status: false, order: productOrders)
//                        print(newOrder.name, newOrder.deadline, newOrder.order, newOrder.price)
                        self.allOrders.append(newOrder)
                      

                       
                       DispatchQueue.main.async {
                           self.collectionView.reloadData()

                       }
                       
                   }
               }
           }
          
       }
    
    
}
   
    
    
    
    
    
    
}
