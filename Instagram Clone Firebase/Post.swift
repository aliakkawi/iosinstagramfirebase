//
//  Post.swift
//  Instagram Clone Firebase
//
//  Created by Ali Akkawi on 10/18/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import Foundation


class Post {
    
    
    private var _name: String
    private var _imageurl: String
    private var _posttext: String
    private var _user_id: String
    private var _post_id: String!
    private var _numOfLikes: Int
    
    
    var name: String {
        
        get{
            
            return self._name
        }
    }
    
    var imageurl: String{
        
        
        get {
            
            return self._imageurl
        }
    }
    
    
    var posttext: String {
        
        get {
            
            return self._posttext
        }
    }
    
    
    var user_id: String {
        
        get {
            
            
            return self._user_id
        }
    }
    
    var post_id: String {
        
        get {
            
            return self._post_id
        }
        
        
        set {
            
            self._post_id = newValue
            
        }
    }
    
    var nuomOfLikes: Int {
        
        get{
            
            return self._numOfLikes
        }
    }
    
    
    init(_name: String, _imageurl: String, _posttext: String, _user_id: String) {
        
        
        self._name = _name
        self._imageurl = _imageurl
        self._posttext = _posttext
        self._user_id = _user_id
        self._numOfLikes = 0
        
        
        
    
    }
}
