//
//  Firebase.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-09-07.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import Firebase


class Firebase {
    var db: Firestore!
    var docRef: DocumentReference!

    func viewDidLoad() {
        db = Firestore.firestore()
    }
    
    func getIngredients(database: String, cv: UICollectionView) -> [String] {
           // [START get_document]
           print("PRODVC getIngredients(): loading cell name via FB")
        var products: [String] = []
        
           db.collection(database).order(by: "name").addSnapshotListener() { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   products = []
                
                   for document in querySnapshot!.documents {
                       
                       let data = document.data()
                       
                       
                       if let dataName = data["name"] as? String {
                          products.append(dataName)
                       }
                       
                       DispatchQueue.main.async {
                          cv.reloadData()
                           
                       }
                       
                   }
               }
           }
        return products
       }
       
}
