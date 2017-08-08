//
//  LoginVC.swift
//  DevChat
//
//  Created by Apostolos Chalkias on 08/08/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: RoundTextField!
    @IBOutlet weak var passwordField: RoundTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    
    @IBAction func loginPressed(_ sender: Any) {
        //Check the fields that are not nill and not empty
        if let email = emailField.text, let pass = passwordField.text , (email.characters.count > 0
            && pass.characters.count > 0) {
            
            //Call the login service
            AuthService.instance.login(email: email, password: pass, onComplete: { (
                errMsg, data) in
                guard errMsg == nil else {
                    //There is an error
                    //Create allert
                    let alert = UIAlertController(title: "Error Authentication", message: errMsg, preferredStyle: .alert)
                    //Add an action
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    //Present
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                //Logged in succesfully dismis current vc
                self.dismiss(animated: true, completion: nil)
            })
            
            
        } else {
            //Create allert
            let alert = UIAlertController(title: "Username and Password Required", message: "You must enter both a username and a password", preferredStyle: .alert)
            //Add an action
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            //Present
            present(alert, animated: true, completion: nil)
        }
    
    
    }

}
