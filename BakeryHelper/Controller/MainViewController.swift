//
//  ViewController.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-07-29.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITabBarControllerDelegate {
  override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        
    }
    @IBAction func order(_ sender: Any) {
        (sender as! UIButton).tag = 0
        performSegue(withIdentifier: "tabBarSegue", sender: sender)
    }
    
    @IBAction func products(_ sender: Any) {
           (sender as! UIButton).tag = 1
           performSegue(withIdentifier: "tabBarSegue", sender: sender)
       }
    
    @IBAction func inventory(_ sender: Any) {
        (sender as! UIButton).tag = 2
        performSegue(withIdentifier: "tabBarSegue", sender: sender)
    }
    
    
    @IBAction func reports(_ sender: Any) {
        (sender as! UIButton).tag = 3
         performSegue(withIdentifier: "tabBarSegue", sender: sender)
    }
    
    @IBAction func shopping(_ sender: Any) {
        (sender as! UIButton).tag = 4
         performSegue(withIdentifier: "tabBarSegue", sender: sender)
    }
    
    
    
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tabBarSegue" {
            if let vc = segue.destination as? UITabBarController {
                vc.selectedIndex = (sender as! UIButton).tag
            }
        }
    }
    
    
    

}

