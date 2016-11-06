//
//  UsersListCustomTableViewCell.swift
//  Instagram Clone Firebase
//
//  Created by Ali Akkawi on 06/11/2016.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit

import Firebase

class UsersListCustomTableViewCell: UITableViewCell {
    
    
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var profileImageView: CustomImageView!
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    
    var tempUserIdInTableLabel: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        ref = FIRDatabase.database().reference()
    }
    
    
    @IBAction func followButtonTapped(_ sender: Any) {
        
        
        let followRef = ref.child("Follows")
        let userInfoRef = ref.child("Usersinfo")
        let currentUserId = FIRAuth.auth()?.currentUser?.uid
        
        
        if followButton.title(for: .normal) == "Follow" {
            
            
            let newValue: [String: AnyObject] = [tempUserIdInTableLabel: emailAddressLabel.text as AnyObject]
            followRef.child(currentUserId!).updateChildValues(newValue)
            
            
            // increase number of following and increase number of followers for the followed user.
            
            
            
            // get the number of following for current user and increase it.
            userInfoRef.child(currentUserId!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let snapshotValue = snapshot.value as! [String: AnyObject]
                let currentFollowingNumberForCurrentuser = snapshotValue["numoffollowing"] as! Int
                let newCurrentFollowingNumberForCurrentuser = currentFollowingNumberForCurrentuser + 1
                // update the value.
                let newCurrentFollowingNumberForCurrentuserDict = ["numoffollowing": newCurrentFollowingNumberForCurrentuser]
                userInfoRef.child(currentUserId!).updateChildValues(newCurrentFollowingNumberForCurrentuserDict)
                usersArray.removeAll(keepingCapacity: true)
                
                
                
                
            })
            
           
            
            // get the number of followers for followed user and increase it.
            
            userInfoRef.child(tempUserIdInTableLabel).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let snapshotValue = snapshot.value as! [String: AnyObject]
                let currentFollowersNumberForFolloweduser = snapshotValue["numoffollowers"] as! Int
                let newcurrentFollowersNumberForFolloweduser = currentFollowersNumberForFolloweduser + 1
                // update the value.
                let newcurrentFollowersNumberForFolloweduserDict = ["numoffollowers": newcurrentFollowersNumberForFolloweduser]
                userInfoRef.child(self.tempUserIdInTableLabel).updateChildValues(newcurrentFollowersNumberForFolloweduserDict)
                usersArray.removeAll(keepingCapacity: true)
                
                
                
                
                
            })
            
            // update the button.
            followButton.backgroundColor = UIColor.green
            followButton.setTitle("Following", for: .normal)
            
            
            
        }else {
            
            
            // unfollow the user.
            
            followRef.child(currentUserId!).child(tempUserIdInTableLabel).removeValue()// delete the followed user.
            
            
            
            // get the number of following for current user and decrease it.
            userInfoRef.child(currentUserId!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let snapshotValue = snapshot.value as! [String: AnyObject]
                let currentFollowingNumberForCurrentuser = snapshotValue["numoffollowing"] as! Int
                let newCurrentFollowingNumberForCurrentuser = currentFollowingNumberForCurrentuser - 1
                // update the value.
                let newCurrentFollowingNumberForCurrentuserDict = ["numoffollowing": newCurrentFollowingNumberForCurrentuser]
                userInfoRef.child(currentUserId!).updateChildValues(newCurrentFollowingNumberForCurrentuserDict)
                usersArray.removeAll(keepingCapacity: true)
                
                
                
                
            })
            
            
            
            // get the number of followers for followed user and decrease it it.
            
            userInfoRef.child(tempUserIdInTableLabel).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let snapshotValue = snapshot.value as! [String: AnyObject]
                let currentFollowersNumberForFolloweduser = snapshotValue["numoffollowers"] as! Int
                let newcurrentFollowersNumberForFolloweduser = currentFollowersNumberForFolloweduser - 1
                // update the value.
                let newcurrentFollowersNumberForFolloweduserDict = ["numoffollowers": newcurrentFollowersNumberForFolloweduser]
                userInfoRef.child(self.tempUserIdInTableLabel).updateChildValues(newcurrentFollowersNumberForFolloweduserDict)
                usersArray.removeAll(keepingCapacity: true)
                
                
                
                
                
            })
            
            
            
            
            
            
            
            // update the button.
            followButton.backgroundColor = UIColor.gray
            followButton.setTitle("Follow", for: .normal)
        }
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
