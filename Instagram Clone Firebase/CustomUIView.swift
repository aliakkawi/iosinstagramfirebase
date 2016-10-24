//
//  CustomUIView.swift
//  Devslopes Social App
//
//  Created by Ali Akkawi on 9/30/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit



class CustomUIView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    
}
