//
//  NavigationViewController.swift
//  instaudemyclone
//
//  Created by Ali Akkawi on 7/25/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
         //preferredStatusBarStyle: UIStatusBarStyle = UIStatusBarStyle.lightContent
        //self.setstat = .lightContent

        // color of TITLE.
        
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // COLOR OF THE BUTTONS.
        
        self.navigationBar.tintColor = UIColor.white
        
        // color of the background of the navigation controller.
        
        self.navigationBar.barTintColor = UIColor(red: 18.0/255.0, green: 86.0/255.0, blue: 136.0/255.0, alpha: 1)
        
        // unable translucent
        
        self.navigationBar.isTranslucent = false
        
        
        
    }

    
    // make to top header that shows the battery level whte as well. (status bar).
    
    
    
    
    
    

    

}
