//
//  PostDetailsViewController.swift
//  Instagram Clone Firebase
//
//  Created by Ali Akkawi on 24/10/2016.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit
import Firebase

class PostDetailsViewController: UIViewController {
    
    var postId = ""
    
    @IBOutlet weak var profileImageView: CustomImageView!
    
    @IBOutlet weak var postImageView: UIImageView!

    @IBOutlet weak var postTextLabel: UILabel!
    
    @IBOutlet weak var numOfLikesLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    
    var numOfLikes = 0 // we set it as a global so we can use it in the like function.
    
    var ref: FIRDatabaseReference!
    var postRef: FIRDatabaseReference!
    var postLikersRef: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(postId)
        
        // query the post class to get the clicked post.
        
        ref = FIRDatabase.database().reference()
        postRef = ref.child("Posts")
        postRef.child(postId).observe(.value, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! [String: AnyObject]
            
            let postText = snapshotValue["posttext"] as! String
            let postImageUrl = snapshotValue["imageurl"] as! String
            self.numOfLikes = snapshotValue["numoflikes"] as! Int
            let postUserid = snapshotValue["user_id"] as! String
            
            self.postTextLabel.text = postText
            
            // download the post image.
            
            self.postImageView.sd_setImage(with: URL(string: postImageUrl), placeholderImage: #imageLiteral(resourceName: "profileimage"), options: [.continueInBackground, .progressiveDownload])
            
            self.numOfLikesLabel.text = "\(self.numOfLikes)"
            
            // adjust the like button.
            
            self.postLikersRef = self.postRef.child(self.postId).child("likers")
            
            self.postLikersRef.child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (likesSnapshot) in
                
                
                if let _ = likesSnapshot.value as? NSNull{
                    
                    self.likeButton.setImage(UIImage(named: "heart"), for: UIControlState.normal)
                }else {
                    
                    self.likeButton.setImage(UIImage(named: "heartfull"), for: UIControlState.normal)
                    
                }
            })
            
            
            
            // query the Usersinfo class in order to get the profile image for the post user.
            
            let userInfoRef = self.ref.child("Usersinfo").child(postUserid)
                userInfoRef.observe(.value, with: { (snapshotUsers) in
                
                let snapshotValueUsersInfo = snapshotUsers.value as! [String: AnyObject]
                
                let profileImageUrl = snapshotValueUsersInfo["profileimage"] as! String
                    
                    // download the image.
                
                    self.profileImageView.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: #imageLiteral(resourceName: "profileimage"), options: [.continueInBackground, .progressiveDownload])
                    
                    
                
            })
            
        })
    }
    
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        
        
        
        print("Num of likes: \(numOfLikes)")
        
        let userId = FIRAuth.auth()?.currentUser?.uid
        
        if likeButton.image(for: .normal) == UIImage(named: "heart"){
            
            
            
            let likeDict: [String : Bool] = [userId!: true]
            postRef.child(postId).child("likers").setValue(likeDict)
            likeButton.setImage(UIImage(named: "heartfull"), for: UIControlState.normal)
            
            // increase the number of likes for the post.
            
            
            // it is recomender to user updatechildvalues rather than setting a new value. It updates only the desired child.
            let newLikesNumber = ["numoflikes": numOfLikes + 1]
            
            
            postRef.child(postId).updateChildValues(newLikesNumber)
            
            
            
        }else {
            
            postRef.child(postId).child("likers").child(userId!).removeValue()
            self.likeButton.setImage(UIImage(named: "heart"), for: UIControlState.normal)
            
            // decrease the number of likes for the post.
            
            let newLikesNumber = ["numoflikes": numOfLikes - 1]
            
            
            postRef.child(postId).updateChildValues(newLikesNumber)
        }
        
        
    }

    @IBAction func backButonTapped(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
