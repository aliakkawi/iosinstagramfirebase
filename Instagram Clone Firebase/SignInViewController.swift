//
//  SignInViewController.swift
//  Instagram Clone Firebase
//
//  Created by Ali Akkawi on 10/16/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    
    var ref: FIRDatabaseReference!

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
        
        
       print("Hello world")
        
    }

   


}

