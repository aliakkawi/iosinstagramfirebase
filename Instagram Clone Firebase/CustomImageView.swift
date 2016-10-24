//
//  CustomImageView.swift
//  Instagram Clone Firebase
//
//  Created by Ali Akkawi on 10/17/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
//        self.layoutIfNeeded()
//        self.layer.cornerRadius = self.frame.size.width / 2
//        self.clipsToBounds = true
        
        
    }
    
    
    // the frame will not be calculated yet in the awakeFromNib function, so we put self.layoutifNeeded(), or we use the layoutSubviews() function.
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
