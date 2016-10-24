//
//  TabBarViewController.swift
//  instaudemyclone
//
//  Created by Ali Akkawi on 7/25/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.tabBar.tintColor = UIColor.white
        self.tabBar.isTranslucent = false
        
        // background color of the tabbar buttons.
        
        self.tabBar.barTintColor = UIColor(red: 37.0/255.0, green: 39.0/255.0, blue: 42.0/255.0, alpha: 1)
        
    }

    

}
