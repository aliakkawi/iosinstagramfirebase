//
//  CustomBg.swift
//  Instagram Clone Firebase
//
//  Created by Ali Akkawi on 10/17/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit

class CustomBg: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bgImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        bgImage.layer.zPosition = -1
        bgImage.image = UIImage(named: "instabg")
        self.addSubview(bgImage)
    }

}
