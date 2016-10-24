//
//  HomeCollectionViewController.swift
//  Instagram Clone Firebase
//
//  Created by Ali Akkawi on 10/17/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit
import Firebase






var posts = [Post]()
class HomeCollectionViewController: UICollectionViewController {
    
    
    var firRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // always vertical scroll
        self.collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white

        
        self.title = "Home"
        //self.navigationController?.hidesBarsOnSwipe = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil) // in order to clear the back button text.
        
        
        firRef = FIRDatabase.database().reference()
        
        let postRef = firRef.child("Posts").queryOrdered(byChild: "user_id").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid)// this will grap only the current users's posts.
        
        
        
        
        
        postRef.observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let posterName = postDict["name"] as! String
                        let imageUrl = postDict["imageurl"] as! String
                        let postText = postDict["posttext"] as! String
                        let posterId = postDict["user_id"] as! String
                        
                        let post: Post = Post(_name: posterName, _imageurl: imageUrl, _posttext: postText, _user_id: posterId)
                        post.post_id = snap.key // we need to store the post id so we can send it to the detail screen and get all the values about the tapped post.

                        posts.append(post)
                        
                    }
                    
                }
            }
            self.collectionView?.reloadData()
        })
        
    }

    

    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell
    
        // Configure the cell
        cell.postImageView.sd_setImage(with: URL(string: posts[indexPath.row].imageurl), placeholderImage: #imageLiteral(resourceName: "imageplaceholder"), options: [.continueInBackground, .progressiveDownload])
    
        return cell
    }
    
    // for the header.
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "homeHeader", for: indexPath) as! HomeHeaderCollectionReusableView
        
        
        
        
        
        // query the Usersinfo.
        
        let currentUsrId = FIRAuth.auth()?.currentUser?.uid
        
        print("Current user id: \(currentUsrId!)")
        let usersInfoRef = firRef.child("Usersinfo").child(currentUsrId!)
        
        usersInfoRef.observe(.value, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! [String: AnyObject]
            
            let currentUserName = snapshotValue["name"] as! String
            let currentUserProfileImage = snapshotValue["profileimage"] as! String
            let currentUserNumOfPosts = snapshotValue["numofposts"] as! Int
            let currentUserNumOfFollowers = snapshotValue["numoffollowers"] as! Int
            let currentUserNumOfFollowing = snapshotValue["numoffollowing"] as! Int
            
            print("the profile image : \(currentUserProfileImage)")
            
            
            header.fullNameLabel.text = currentUserName
            header.emailAddressLabel.text = FIRAuth.auth()?.currentUser?.email
            header.numOfPostsLabel.text = "\(currentUserNumOfPosts)"
            header.numOfFollowers.text = "\(currentUserNumOfFollowers)"
            header.numOfFollowing.text = "\(currentUserNumOfFollowing)"
            
            
            // download the profile image.
            
            header.profileImage.sd_setImage(with: URL(string: currentUserProfileImage), placeholderImage: #imageLiteral(resourceName: "profileimage"), options: [.continueInBackground, .progressiveDownload])
            //self.collectionView?.reloadData()
        })
        
        
        
        
        
        
        
        
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Post key: \(posts[indexPath.row].post_id)")
        
        let postDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
        
        
        postDetailsViewController.postId = posts[indexPath.row].post_id
        present(postDetailsViewController, animated: true, completion: nil)
    }
    
    
    // resize the cell
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath:
        IndexPath) -> CGSize {
        let sideSize = (traitCollection.horizontalSizeClass == .compact &&
            traitCollection.verticalSizeClass == .regular) ? 100.0 : 160.0
        return CGSize(width: sideSize, height: sideSize)
    }
    
    
    //Respond to the Change of Size Class
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator:
        UIViewControllerTransitionCoordinator) {
        collectionView!.reloadData()
    }
    
    
    @IBAction func signOutTapped(_ sender: AnyObject) {
        
        try! FIRAuth.auth()!.signOut()
        //dismiss(animated: true, completion: nil)
        
        let signInViewController = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.present(signInViewController, animated: true, completion: nil)
    }
    
    

    

}
