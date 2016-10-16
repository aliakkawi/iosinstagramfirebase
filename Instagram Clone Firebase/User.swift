//
//  User.swift
//  Instagram Clone Firebase
//
//  Created by Ali Akkawi on 10/16/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import Foundation

class User {
    
    
    private var _name: String
    private var _age: Int
    
    var name: String {
        
        
        
        get {
            
            return self._name
        }
    }
    
    var age: Int {
        
        get {
            
            
            return self._age
        }
    }
    
    
    init(_name: String, _age: Int) {
        
        
        self._name = _name
        self._age = _age
    }
}
