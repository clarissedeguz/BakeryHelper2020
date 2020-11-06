//
//  ProductGrid.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-09-07.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class ProductGrid: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var db: Firestore!
    var docRef: DocumentReference!
    var products: [String] = []
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spaceBetweenCells = 12
        let width = (Int(self.collectionView.frame.size.width) - spaceBetweenCells * 3) / 3
        let height = (Int(self.collectionView.frame.size.height) - spaceBetweenCells * 15) / 3
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: -5, left: 10, bottom: 0, right: 10)
    }
    
    func cvSpecs() {
        collectionView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier:  0).isActive = true
        collectionView.trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor, multiplier: 0).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        collectionView.contentInset.top = 20
        collectionView.contentInset.bottom = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        cvSpecs()
        db = Firestore.firestore()
    }
    
    func getIngredients(databaseCollection: String) {
        // [START get_document]
        print("PRODVC getIngredients(): loading cell name via FB")
        
        
        db.collection(databaseCollection).order(by: "name").addSnapshotListener() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                self.products = []
                
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    
                    
                    if let dataName = data["name"] as? String {
                        self.products.append(dataName)
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        
                    }
                    
                }
            }
        }
       
    }
    
}

