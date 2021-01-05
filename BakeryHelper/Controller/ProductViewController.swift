//
//  ProductViewController.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-08-08.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import ChameleonFramework

class ProductViewController: ProductGrid, ProductDelegate, ProductDetailDelegate {
    
    private let cellId = "prodCell"
    fileprivate var productArray: [Product] = []
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProductCell
        cell.backgroundColor = UIColor(hexString: "80BB93", withAlpha: 0.5)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(12))
        cell.button.setTitle(products[indexPath.row], for: .normal)
        cell.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      loadIng(at: indexPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getIngredients(databaseCollection: ProdForm.dbName)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: cellId)
        cvSpecs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.productArray.removeAll()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "goToProdForm" {
               if let nextViewController = segue.destination as? UINavigationController {
                   if let vc = nextViewController.viewControllers.first as? ProdFormViewController {
                       vc.delegate = self
                   }
               }
           }
        
        if segue.identifier == "goToDetails" {
            if productArray.count == 1 {
            if let nextViewController = segue.destination as? ProdDetailViewController {
                nextViewController.delegate = self
                }
                
                
            }
            
        }
    }
    
    func getData() -> [Product] {
          let newArray = productArray
          print("PRODVC getData() FIRST ITEM: \(newArray[0].name)")
          return newArray
      }
    
    func loadIng(at indexPath: IndexPath)  {
        let prodToLoad = self.products[indexPath.row]
        print("PRODVC loadIng() CELL PRESSED: \(prodToLoad)")
        db.collection(ProdForm.dbName).whereField("name", isEqualTo: prodToLoad)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    for document in querySnapshot!.documents {
                        print("PRODVC loadIng() Starting query for document via FB")
                        let data = document.data()
                        
                        
                        
                        guard let dataName = data["name"] as? String,
                            let dataServing = data["serving"] as? Double,
                            let dataPrice = data["price"] as? Float
                            
                            else {
                                fatalError()
                        }
                        
                        print("PRODVC loadIng() NAME & SERVING: \(dataName), \(dataServing)")
                        
                        if let dryDataIng = data["dry ingredients"] as? [[String: [String : AnyObject]]], let wetDataIng = data["wet ingredients"] as? [[String: [String : AnyObject]]] {
                            
                            
                            let wetIngDict = self.firebaseIng(items: wetDataIng)
                            let dryIngDict = self.firebaseIng(items: dryDataIng)
                            let newProd = Product(name: dataName,wetIngItems: dryIngDict,dryIngItems: wetIngDict, serving:dataServing, price: dataPrice)
                            self.productArray.append(newProd)
                            
                            DispatchQueue.main.async {
                                if self.productArray.count == 1 {
                                    self.performSegue(withIdentifier: "goToDetails", sender: Any.self)
                                }
                            }
                            
                        }
                        
                    }
                }
        }
        
    }
    func firebaseIng(items: [[String: [String:AnyObject]]]) -> [String: [String:Double]] {
        
        var newDict: [String:[String:Double]] = [:]
        
        for index in items {
            for (key, value) in index {
                
                let newKey = key //(String)
                let newVal = value //[String: Int)
                
                for (key, value) in newVal {
                    
                    var newDict2: [String: Double] = [:]
                    let newKey2 = key //(String)
                    
                    if let newVal2 = value as? Double {
                        newDict2[newKey2] = newVal2
                        newDict[newKey] = newDict2
                        
                    }
                }
            }
        }
        
        return newDict
}

}
