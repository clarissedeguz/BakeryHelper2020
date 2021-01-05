//
//  LoginViewController.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-10-22.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    let segue = "homeSegue"
    
    @IBAction func login(_ sender: UIButton) {
        
        if let usernameLog = username.text, let passwordLog = password.text {
            Auth.auth().signIn(withEmail: usernameLog, password: passwordLog) {  authResult, error in
                
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: self.segue, sender: self)
                }
                
            }
        }
        
    }
    
    
    
    
    @IBAction func register(_ sender: UIButton) {
        if let usernameReg = username.text , let passwordReg = password.text {
                  
                  Auth.auth().createUser(withEmail: usernameReg, password: passwordReg) { authResult, error in
                      if let e = error {
                          
                          //we can create a popup or display in text to display error
                          //localized Description = error will pop up in lang. that user's phone is set
                          print(e.localizedDescription)
                      } else {
                        self.performSegue(withIdentifier: self.segue, sender: self)
                          
                          
                      }
                  }
              }
        
    }
    
    
    
    
    
    
    
}



