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
    private var _numoffollowers: Int
    private var _numoffollowing: Int
    private var _numofposts: Int
    private var _profileimage: String
    private var _userId: String
    
    var name : String {
        
        
        get {
            
            return self._name
        }
    }
    
    
    var userId: String {
        
        
        get {
            
            return self._userId
        }
    }
    
    
    var numoffollowers: Int {
        
        
        get {
            
            return self._numoffollowers
        }
    }
    
    
    var numoffollowing: Int {
        
        get {
            
            return self._numoffollowing
        }
    }
    
    
    
    var numofposts: Int {
        
        
        get{
            
            return self._numofposts
        }
    }
    
    
    
    var profileimage: String {
        
        
        get {
            
            return self._profileimage
        }
    }
    
    init(){
        
        self._name = ""
        self._numoffollowers = 0
        self._numoffollowing = 0
        self._numofposts = 0
        self._profileimage = ""
        self._userId = ""
    }
    
    
    init(_name: String, _profileimage: String) {
        
        
        self._name = _name
        self._numoffollowers = 0
        self._numoffollowing = 0
        self._numofposts = 0
        self._profileimage = _profileimage
        self._userId = ""
    }
    
    
    init(_name: String, _profileImage: String, _numoffollowers: Int, _numoffollowing: Int, _numofposts: Int, _userId: String) {
        
        self._name = _name
        self._profileimage = _profileImage
        self._numoffollowers = _numoffollowers
        self._numoffollowing = _numoffollowing
        self._numofposts = _numofposts
        self._userId = _userId
    }
    
    
}
