//
//  HomeHeaderCollectionReusableView.swift
//  Instagram Clone Firebase
//
//  Created by Ali Akkawi on 22/10/2016.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit

class HomeHeaderCollectionReusableView: UICollectionReusableView {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var numOfPostsLabel: UILabel!
        
    @IBOutlet weak var numOfFollowers: UILabel!
    
    @IBOutlet weak var numOfFollowing: UILabel!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var emailAddressLabel: UILabel!
}
