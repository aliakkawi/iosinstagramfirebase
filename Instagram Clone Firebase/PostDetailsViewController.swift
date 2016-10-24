//
//  PostDetailsViewController.swift
//  Instagram Clone Firebase
//
//  Created by Ali Akkawi on 24/10/2016.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController {
    
    var postId = ""
    @IBOutlet weak var testLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        testLabel.text = postId
    }
    
    

    @IBAction func backButonTapped(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
