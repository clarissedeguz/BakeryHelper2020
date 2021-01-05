//
//  OrderProdSel.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-09-06.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol prodSelectDelegate {
    func getData(array: [String])
}



class OrderProdSelectionViewController: ProductGrid {
    
    var textFieldInfo: [String] = []
    
    var delegate: prodSelectDelegate?

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! OrderSelCell
        cell.backgroundColor = UIColor(hexString: "80BB93", withAlpha: 0.5)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(12))
        cell.label.text = products[indexPath.row]
        cell.label.textColor = .white
        cell.label.font =  UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        cvSpecs()
        collectionView.register(OrderSelCell.self, forCellWithReuseIdentifier: "MyCell")
        getIngredients(databaseCollection: ProdForm.dbName)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let newCellSel = products[indexPath.row]
        
        self.textFieldInfo.append(newCellSel)
        
       
        
    }
    
    
    
    @IBAction func done(_ sender: UIBarButtonItem) {
         print(textFieldInfo.count)
        delegate?.getData(array: textFieldInfo)
        dismiss(animated: true)
    }
    
    
    
    
}


    
    
    
    
    

