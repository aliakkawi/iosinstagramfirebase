//
//  SignInViewController.swift
//  Instagram Clone Firebase
//
//  Created by Ali Akkawi on 10/16/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    
    var ref: FIRDatabaseReference!
    

    @IBOutlet var emailTextField: MaterialTextField!
    
    @IBOutlet var passwordTextField: MaterialTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Test the Database
        /*
        
        let user1 = User(_name: "ALi", _age: 31)
        let user2 = User(_name: "Shoshi", _age: 3)
        
        let usersArray: Array<User> = [user1, user2]
        
        for i in 0..<usersArray.count {
            
            ref = FIRDatabase.database().reference().child("test").childByAutoId()
            let post: [String: AnyObject] = ["name": usersArray[i].name as AnyObject, "age": usersArray[i].age as AnyObject]
            ref.setValue(post)
            
            
        }
        
        */
        
        
       // check for the authentication state.
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            if user != nil {
                
                
                self.performSegue(withIdentifier: "gohomein", sender: nil)
            }
            
        })
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        
        return false
    }

   
    @IBAction func signInTapped(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        
        if let email = emailTextField.text, let password = passwordTextField.text{
            
            
            if email == "" || password == "" {
                
                displayAlert(title: "Alert", message: "Please fill in all fields")
                
            }else {
                
                
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    
                    
                    
                    if error == nil {
                        
                        // make a new user in the database.
                        
                        let successAlert = UIAlertController(title: "Success", message: "Successfully signed in", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "oK", style: .default, handler: { (action) in
                            
                            self.performSegue(withIdentifier: "gohomein", sender: nil)
                        })
                        
                        successAlert.addAction(okAction)
                        self.present(successAlert, animated: true, completion: nil)
                        
                    }else {
                        
                        self.displayAlert(title: "Alert", message: (error?.localizedDescription)!)
                        
                    }
                })
                
            }
        
        
        
        }
        
        
        
        
    }
        
        
    func displayAlert(title: String, message: String){
        
        
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        myAlert.addAction(okAction)
        present(myAlert, animated: true, completion: nil)
        
    }

}

