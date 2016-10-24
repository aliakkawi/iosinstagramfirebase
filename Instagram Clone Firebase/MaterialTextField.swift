//
//  MaterialTextField.swift
//  Devslopes Social App
//
//  Created by Ali Akkawi on 9/30/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {
    
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }
    
    
    
    // For the placeholder
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    // FOR EDITABLE TEXT.
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    
    
}
