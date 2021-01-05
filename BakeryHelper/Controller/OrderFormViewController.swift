//
//  OrderFormViewController.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-09-06.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MiseEnPlace

//It would populate overall name, deadline, and product order
class OrderFormViewController: UIViewController, prodSelectDelegate, Convertable {
    
    

    //Part of MiseEnPlace
    var measurement: CookingMeasurement = CookingMeasurement(amount: 0, unit: .milliliter)
    
    var ratio: Ratio = Ratio(volume: 0.45, weight: 0.45)
    
    var eachMeasurement: CookingMeasurement?
    
    var db: Firestore!
    var docRef: DocumentReference!
    var formMod = FormModel()
    
    let myCell = "cellId"
    var headerTitle: [String] = ["Name", "Deadline", "Order"]
    var productOrder : [String] = []
    var productOrderArray: [Product] = []
    var test: [Int: Double] = [:]
    var inventoryArray: [Ingredient] = []
   
    
    let closeHeight: CGFloat = 91
    let openHeight: CGFloat = 166
    var itemHeight = [CGFloat](repeating: 91.0, count: 100)
    
    let tableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    func tableViewSpecs() {
        tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        tableView.separatorStyle = .singleLine
    }
    let addBut: UIButton = {
        let addBut = UIButton()
        addBut.setTitle("Add", for: .normal)
        addBut.setTitleColor(.flatTealDark(), for: .normal)
        addBut.isUserInteractionEnabled = true
        addBut.titleLabel?.font = UIFont(name: "system", size: 10)
        return addBut
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrderFormCell.self, forCellReuseIdentifier: myCell)
        tableViewSpecs()
        db = Firestore.firestore()
    }
    @objc func buttonTapped(sender: UIButton) {
        performSegue(withIdentifier: "prodSelect", sender: sender)
    }

    func getData(array: [String]) {
        productOrder = array
        tableView.reloadData()
        loadProdInfo()
        loadInventoryInfo()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "prodSelect", let nextViewController = segue.destination as? UINavigationController, let vc = nextViewController.viewControllers.first as? OrderProdSelectionViewController  {
            vc.delegate = self
        }
    }
    
    func loadProdInfo()  { //Product Databse
        for products in productOrder {
            let prodToLoad = products
            db.collection(ProdForm.dbName).whereField("name", isEqualTo: prodToLoad)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            
                            guard let dataName = data["name"] as? String,
                                let dataServing = data["serving"] as? String,
                                let dataPrice = data["price"] as? Float,
                                
                                let serving = Double(dataServing)
                               
                            
                                else {
                                    fatalError()
                            }
                            if let wetDataIng = data["wet ingredients"] as? [[String: [String: AnyObject]]], let dryDataIng = data["dry ingredients"] as? [[String: [String : AnyObject]]] {
                                
                                let wetIngItems = self.firebaseIng(items: wetDataIng)
                                let dryIngItems = self.firebaseIng(items: dryDataIng)
                                
                                DispatchQueue.main.async {
                                    let newProd = Product(name: dataName, wetIngItems: wetIngItems, dryIngItems: dryIngItems, serving: serving, price: dataPrice)
                                    print(newProd)
                                    self.productOrderArray.append(newProd)
                                }
                                
                                
                            }
                        }
                    }
            }
        }
    }
    
    
    func firebaseIng(items: [[String: [String: AnyObject]]]) -> [String:[String: Double]] {
        var dict: [String: [String: Double]] = [:]
        
        for index in items {
            for (key, value) in index {
                
                let newKey = key //(String) ???????
                let newVal = value //[String: Int] ????????
                
                for (key, value) in newVal {
                    
                    var newDict2: [String: Double] = [:]
                    let newKey2 = key //(String) ???????????????????????????
                    
                    if let newVal2 = value as? Double {
                        newDict2[newKey2] = newVal2
                        dict[newKey] = newDict2
                        
                    }
                }
            }
        }
        return dict
    }
    func loadInventoryInfo()  { //Inventory Database
        db.collection(InvForm.dbName).order(by: "name").addSnapshotListener() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    guard let dataName = data["name"] as? String,
                        let dataType = data["type"] as? String,
                        let dataAmnt = data["amount"] as? Double,
                        let dataNotifVal = data["notifValue"] as? Double,
                        let dataMeasurement = data["measurement"] as? String
                        else {
                            fatalError()
                    }
                    DispatchQueue.main.async {
                        let invItem = Ingredient(name: dataName, type: dataType, amount: dataAmnt, measurement: dataMeasurement, minimum: dataNotifVal)
                        self.inventoryArray.append(invItem)
                        
                    }
                    
                    
                }
            }
        }
    }
    
     
    //check #1: Is the product ingredients in the inventory databse
    func inventoryCheck(for products: [Product]) -> Bool {
        
        var invCheckPass: [String] = []
        products.forEach { (item) in
            print("prodOrdArrItem: \(item.name)")
            var allIng = item.dryIngItems
            let wetIng = item.wetIngItems
            wetIng.forEach { (k, v) in //combining all Ingredients
                if k != "Water" {
                allIng[k] = v
                }
            }
            var weGotIt: [String] = []
            for (k , _) in allIng {
                print("ingItem: \(k)")
                if inventoryArray.contains(where: { $0.name == k }) {
                    print("we got it boys \(k)")
                    weGotIt.append(k)
                } else {
                    print("we do not got it \(k)")
                }
            }
            if weGotIt.count == allIng.count { //if we have all the ing in the inventory
                invCheckPass.append(item.name)
            }
        }
        
        if invCheckPass.count == products.count {
            return true
        } else {
            return false
        }
    }
    
    func inventoryIngItems(type: IngType) -> [String: MeasurementUnit] {
        var invIngItems: [String: MeasurementUnit] = [:]
        
        for i in inventoryArray {
            let invItemName = i.name
            let invItemMeas = conversion(measurement: i.measurement ?? "")
            let invItemType = i.type
            
            if invItemType == type.rawValue {
                invIngItems[invItemName] = invItemMeas
            }
        }
        
        return invIngItems
    }
    
    func productIngItems(type: IngType, product: Product) -> [String: [MeasurementUnit: Double]] {
        var prodIngItems: [String: [MeasurementUnit: Double]] = [:]
        if type == .wetIngredient {
            let prodWetIng = product.wetIngItems
            for (k, v) in prodWetIng {
                let prodIngName = k
                let prodIngVal = v
                var measurement: MeasurementUnit
                
                for (m, a) in prodIngVal {
                    let amount = a
                    measurement = conversion(measurement: m)
                    prodIngItems[prodIngName] = [measurement : amount]
                }
            }
            
        } else {
            let prodDryIng = product.dryIngItems
            for (k, v) in prodDryIng {
                let prodIngName = k
                let prodIngVal = v
                var measurement: MeasurementUnit
                
                for (m, a) in prodIngVal {
                    let amount = a
                    measurement = conversion(measurement: m)
                    prodIngItems[prodIngName] = [measurement : amount]
                    
                }
            }
            
        }
        print(prodIngItems.keys, type)
        return prodIngItems
    }
    
    func conversion(measurement: String) -> MeasurementUnit {
        
        switch measurement  {
        case "l": return MeasurementUnit.liter
        case "ml": return MeasurementUnit.milliliter
        case "cups": return MeasurementUnit.cup
        case "tbsp": return MeasurementUnit.tablespoon
        case "tsp": return MeasurementUnit.teaspoon
        case "g": return MeasurementUnit.gram
        case "kg": return MeasurementUnit.kilogram
        case "lb": return MeasurementUnit.pound
        case "oz": return MeasurementUnit.ounce
        default: return MeasurementUnit.asNeeded
        }
        
    }
    
    //check #2: Is the product ingredient the same measurement as the inventory item
    func conversionCheck1() {
        var readyToGo: [[String: Double]] = []
        var check: Bool = true
        let inventoryWetIng = inventoryIngItems(type: .wetIngredient)
        let inventoryDryIng = inventoryIngItems(type: .dryIngredient)
        
        print("conversionCheck1(): inventoryDryIng = \(inventoryDryIng.keys)")
        print("conversionCheck1(): inventoryWetIng = \(inventoryWetIng.keys)")
        
        for p in productOrderArray {
            for (k, v) in productIngItems(type: .wetIngredient, product: p) {
                let prodWetIngName = k
                let prodWetIngVal = v
                var amount: Double = 0
                var measurement: MeasurementUnit = MeasurementUnit.asNeeded
              
                for (m, a) in prodWetIngVal {
                    amount = a
                    measurement = m
                    print("ProdWetIng(\(prodWetIngName)): \(amount), \(measurement)")
                }
                
                check = conversionCheck2(prodIngName: prodWetIngName, prodIngMeasurement: measurement, inventory: inventoryWetIng)
                
                print("conversionCheck1(Wet): \(prodWetIngName), \(check)")
                
                if check == false {
                    let newItem = ingConversion(inv: inventoryWetIng, pIngN: prodWetIngName, pIngM: measurement, pIngA: amount)
                    readyToGo.append(newItem)
                } else {
                    let goodToGoIng = [prodWetIngName: amount]
                    readyToGo.append(goodToGoIng)
                }
            }
            
            for (k, v) in productIngItems(type: .dryIngredient, product: p) {
                let prodDryIngName = k
                let prodDryIngVal = v
                var measurement: MeasurementUnit = MeasurementUnit.asNeeded
                var amount: Double = 0
                
                for (m, a) in prodDryIngVal {
                    amount = a
                    measurement = m
                     print("ProdDryIng(\(prodDryIngName)): \(amount), \(measurement)")
                }
                
               check = conversionCheck2(prodIngName: prodDryIngName, prodIngMeasurement: measurement, inventory: inventoryDryIng)
                
                print("conversionCheck1(Dry): \(prodDryIngName), \(check)")
                
                if check == false {
                    let newItem = ingConversion(inv: inventoryDryIng, pIngN: prodDryIngName, pIngM: measurement, pIngA: amount)
                    readyToGo.append(newItem)
                } else {
                    let goodToGoIng = [prodDryIngName: amount]
                    readyToGo.append(goodToGoIng)
                }
            }
            
            }
            
        }
    
    //check#2 A: is prodIng the same measurement as invIng
    func conversionCheck2(prodIngName: String, prodIngMeasurement: MeasurementUnit, inventory: [String: MeasurementUnit]) -> Bool {
        if inventory[prodIngName] != nil {
            if inventory[prodIngName] == prodIngMeasurement {
                print("conversionCheck2(): \(prodIngName), \(inventory[prodIngName] ?? MeasurementUnit.asNeeded) its the same")
                return true
            } else {
                print("conversionCheck2(): \(prodIngName) bruh convert it")
                return false
            }
        } else {
            return false
        }
    }
    
    //check#2 B: Converting to the same measurement
    func ingConversion(inv: [String: MeasurementUnit], pIngN: String, pIngM: MeasurementUnit, pIngA: Double) -> [String: Double] {
        
        var newItem: [String: Double] = [:]
        var amount: Double = 0
        
        
        /*
         1. check if its the same MeasurementSysMethod
         2. Then you can use convert
         */
        
        
        if let inventoryMeasurement = inv[pIngN] {
            
            let invMethod = inventoryMeasurement.measurementSystemMethod
            let pMethod = pIngM.measurementSystemMethod
            
            
            if invMethod == pMethod {
                //convert can only be used within the same system method
                amount = pIngA.convert(from: pIngM, to: inventoryMeasurement)
                print("ingConversion(): invMeasurement: \(inventoryMeasurement), prodIngMeasurement: \(pIngM), \(pIngA)")
            } else {
                
                
                
                
                
                
            }
        }
        
        newItem[pIngN] = amount
        print("ingConversion(): \(newItem)")
        return newItem
    }
    
    
    
    
   
    func saveOrder(){
        let check1 = inventoryCheck(for: productOrderArray)
        if check1 == true {
            conversionCheck1()
            
        } else {
            print("Not Enough ingredients in the inventory")
        }
        
        
        print(check1)
    }
    
    
    
    
    
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        saveOrder()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func stepperValueGrab(stepper: UIStepper, newValue: Double, at index: Int) {
        test[index] = newValue
    }
    
    
    
}















//MARK: - UITableViewDelegate

extension OrderFormViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCell, for: indexPath) as! OrderFormCell
    
        
        cell.delegate = self
        cell.setup(delegate: self)
        
        cell.textField.frame = CGRect(x: 15, y: 0, width: cell.frame.width, height: cell.frame.height)
        cell.contentView.addSubview(cell.textField)
        
        cell.textField.tag = indexPath.section
      
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Deadline Date"
            cell.textField.autocorrectionType = .no
            cell.textField.setInputViewDatePicker(target: cell, selector: #selector(cell.tapDone))
        case 2:
            cell.contentView.addSubview(cell.myUIStepper)
            cell.contentView.addSubview(cell.label)
            cell.myUIStepper.tag = indexPath.row
            cell.textField.isHidden = true
            cell.textLabel?.text = productOrder[indexPath.row]
            cell.myUIStepper.addTarget(cell, action: #selector(cell.stepperValueChanged(sender:)), for: .valueChanged)
            
        
        default:
            print("")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           switch section {
           case 2:
               return productOrder.count
           default:
               return 1
           }
           
       }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        footerView.backgroundColor = .white
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 3
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = tableView.frame
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        headerView.backgroundColor = .none
        let label = UILabel(frame: CGRect(x: 15, y: 25, width: 150, height: 25))
        label.text = headerTitle[section]
        label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
        label.textColor = UIColor(hexString: "80BB93", withAlpha: 1.0)
        headerView.addSubview(label)
      
        switch section {
        case 2:
            addBut.frame = CGRect(x: 350, y: 18, width: 40, height: 40)
            addBut.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            headerView.addSubview(addBut)
            return headerView
            
        default:
            return headerView
        }
        
    }

}
//MARK: - UITextField Delegate

extension OrderFormViewController: OrderFormDelegate {
    
    func textFieldShouldEndEditing(text: String, textFieldTag: Int) {
        switch textFieldTag {
        case 0:
            formMod.name = text
        case 1:
            formMod.date = text
        default:
            print("hey")
        }
    }
}


