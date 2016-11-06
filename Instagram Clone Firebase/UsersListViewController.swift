//
//  UsersListViewController.swift
//  Instagram Clone Firebase
//
//  Created by Ali Akkawi on 06/11/2016.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit
import Firebase

var usersArray = [User]()
class UsersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var ref: FIRDatabaseReference!
    
    let storage = FIRStorage.storage()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        ref = FIRDatabase.database().reference()
        let usersInfoRef = ref.child("Usersinfo")
        
        usersInfoRef.observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] { // this will give us the children
                
                for snap in snapshot {
                    
                    if let usersDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let userName = usersDict["name"] as! String
                        let profileImageUrl = usersDict["profileimage"] as! String
                        let numOfFollowers = usersDict["numoffollowers"] as! Int
                        let numOfFollowing = usersDict["numoffollowing"] as! Int
                        let numOfPosts = usersDict["numofposts"] as! Int
                        let userId = snap.key
                        
                        
                        let user: User = User(_name: userName, _profileImage: profileImageUrl, _numoffollowers: numOfFollowers, _numoffollowing: numOfFollowing, _numofposts: numOfPosts, _userId: userId)
                        
                        
                        
                        usersArray.append(user)
                        
                    }
                    
                }
            }
            self.tableView?.reloadData()
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userscell", for: indexPath) as! UsersListCustomTableViewCell
        
        cell.emailAddressLabel.text = usersArray[indexPath.row].name
        cell.tempUserIdInTableLabel = usersArray[indexPath.row].userId
        
        
        // display the profile images using the cashe.
        
        if let cacheImg = UsersListViewController.imageCache.object(forKey: usersArray[indexPath.row].profileimage as NSString) {
            
            cell.profileImageView.image = cacheImg
        }else {
            
            let ref = FIRStorage.storage().reference(forURL: usersArray[indexPath.row].profileimage)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                if error != nil {
                    
                    print("Unable to download image from storage.")
                }else {
                    
                    if let imgData = data {
                        
                        if let img = UIImage(data: imgData){
                            cell.profileImageView.image = img
                            UsersListViewController.imageCache.setObject(img, forKey: usersArray[indexPath.row].profileimage as NSString) // we save image to the cache so we can access it later using the cache/
                            
                        }
                    }
                    
                }
            })
        }
        
        
        // adjust the follow button.
        
        let followRef = ref.child("Follows")
        
        let currentUserId = FIRAuth.auth()?.currentUser?.uid
        followRef.child(currentUserId!).observeSingleEvent(of: .value, with: { (followSnapshot) in
            
            
            if followSnapshot.hasChild(usersArray[indexPath.row].userId){
                
                cell.followButton.backgroundColor = UIColor.green
                cell.followButton.setTitle("Following", for: .normal)
                
            }else {
                
                cell.followButton.backgroundColor = UIColor.gray
                cell.followButton.setTitle("Follow", for: .normal)
                
            }
        })
        
        return cell
    }
    
    
    

    

}
