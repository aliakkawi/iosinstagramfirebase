//
//  FancyButton.swift
//  Devslopes Social App
//
//  Created by Ali Akkawi on 9/30/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit

class FancyButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize.zero
        layer.cornerRadius = 2.0
    }

}
