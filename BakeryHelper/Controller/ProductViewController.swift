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




class ProductViewController: UIViewController, ProductDelegate, ProductDetailDelegate {
    
    
    var db: Firestore!
    var docRef: DocumentReference!
   
    
    private let cellId = "prodCell"
    private let itemsPerRow: CGFloat = 3
    private let sectionInset = UIEdgeInsets(top: -30, left: 15, bottom: -30, right: 15)

    
    fileprivate var productsArray: [String] = []
    fileprivate var productArray: [Product] = []
    fileprivate var product = Product(name: "", ingItems: [:], serving: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        cvSpecs()
        registerCells()
        db = Firestore.firestore()
    }
    
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 20
       
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = true
        cv.backgroundColor = .flatWhite()
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    
    func cvSpecs() {
        
        collectionView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier:  0).isActive = true
        collectionView.trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor, multiplier: 0).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        collectionView.contentInset.top = 20
        collectionView.contentInset.bottom = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getIngredients()
        self.productArray.removeAll()
        self.collectionView.reloadData()
        print("PRODVC viewDidApp() PRODARRAY COUNT: \(productArray.count)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("PRODVC viewDidDis() PRODARRAY COUNT: \(productArray.count)")
    }
    
    
    
    
    func getIngredients() {
        // [START get_document]
        print("PRODVC getIngredients(): loading cell name via FB")
        db.collection(ProdForm.dbName).order(by: "name").addSnapshotListener() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                self.productsArray = []
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    if let dataName = data["name"] as? String {
                        self.productsArray.append(dataName)
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        
                    }
                    
                }
            }
        }
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
       
    
    
    func loadIng(at indexPath: IndexPath)  {
        let prodToLoad = self.productsArray[indexPath.row]
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
                                let dataServing = data["serving"] as? Int
                                
                                else {
                                    fatalError()
                            }
                            
                            print("PRODVC loadIng() NAME & SERVING: \(dataName), \(dataServing)")
                            
                            if let dataIng = data["ingredients"] as? [[String: [String : AnyObject]]] {
                               
                                for index in dataIng {
                                    
                                    var newDict: [String:[String:Int]] = [:]
                                    
                                    for (key, value) in index {
                                        
                                        let newKey = key //(String)
                                        let newVal = value //[String: Int)
                                        
                                        for (key, value) in newVal {
                                            
                                        var newDict2: [String: Int] = [:]
                                        let newKey2 = key //(String)
                                            
                                        if let newVal2 = value as? Int {
                                            newDict2[newKey2] = newVal2
                                            print(newDict2)
                                            newDict[newKey] = newDict2
                                            print(newDict)
                                            }
                                        }
                                    }
                                    
                                    print("PRODVC loadIng() INGREDIENTS: \(newDict)")
                                    self.product = Product(name: dataName, ingItems: newDict, serving: dataServing)
                                    self.productArray.append(self.product)
                                    
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
       
       
    }
    
    
    
    func getData() -> [Product] {
        let newArray = productArray
        print("PRODVC getData() FIRST ITEM: \(newArray[0].name)")
        return newArray
    }
    
   
    
    
}



//MARK: - UICollectionView Delegate



extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        return productsArray.count
    //    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProductCell
        cell.backgroundColor = UIColor(hexString: "80BB93", withAlpha: 0.5)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(12))
        //        cell.backgroundColor = UIColor(hexString: "80BB93", withAlpha: 0.5)
        cell.button.setTitle(productsArray[indexPath.row], for: .normal)
        cell.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
     
        
        
        return cell
    }
    
    
    func registerCells() {
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let paddingSpace = sectionInset.left * (itemsPerRow + 1)
        //        let availableWidth = view.frame.width - paddingSpace
        //        let widthPerItem = availableWidth / itemsPerRow
        //
        //        let paddingSpaceH = sectionInset.top * (itemsPerRow + 1)
        //        let availableHeight = view.frame.height - paddingSpaceH
        //        let heightPerItem = availableHeight / itemsPerRow
        
        let spaceBetweenCells = 12
        let width = (Int(self.collectionView.frame.size.width) - spaceBetweenCells * 3) / 3
        let height = (Int(self.collectionView.frame.size.height) - spaceBetweenCells * 15) / 3
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: -5, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
      loadIng(at: indexPath)
        
        
       
        
        
        
        
    }
    
    
   
   
    
}

