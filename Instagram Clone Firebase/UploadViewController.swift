//
//  UploadViewController.swift
//  Instagram Clone Firebase
//
//  Created by Ali Akkawi on 10/17/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var postTextView: UITextView!
    
    @IBOutlet weak var publishButton: UIButton!

    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var removeButton: UIButton!
    
    var ref: FIRDatabaseReference!
    var postRef: FIRDatabaseReference!
    
    let storage = FIRStorage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    
    
    
    }

    @IBAction func postImageTapped(_ sender: AnyObject) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        myPickerController.allowsEditing = true // this will allow us to cut (crop) the image.
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    
    // Will be called when picking an image from the UIImagePickerController.
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        postImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        publishButton.isUserInteractionEnabled = true
        publishButton.isEnabled = true
        publishButton.backgroundColor = UIColor(red: 52.0/255.0, green: 160.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        removeButton.isEnabled = true
        
        //Dismiss image picker controller.
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    @IBAction func removeButtonTapped(_ sender: AnyObject) {
        
        postImage.image = UIImage(named: "imageplaceholder")
        publishButton.backgroundColor = UIColor.lightGray
        publishButton.isEnabled = false
    }
    
    
    @IBAction func publishButtonTapped(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        // upload the image.
        
        // display the spinning.
        
        let spiningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        // we can also change the label text and the font color.  Very nice
        spiningActivity?.labelText = "Submitting your post"
        spiningActivity?.detailsLabelText = "Please wait"
        
        
        if let thePostImage = postImage.image {
            
            
            posts.removeAll(keepingCapacity: false) // we need to empty the array so that no duplicates will
            
            if let imageData = UIImageJPEGRepresentation(thePostImage, 0.2){
                
                let imgUid = NSUUID().uuidString
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                
                let postStorageReference = storage.reference().child("post_images").child(imgUid)
                postStorageReference.put(imageData, metadata: metadata, completion: { (metadata, error) in
                    if error != nil {
                        
                        
                        print("Unable to Upload the post image")
                    }else {
                        
                        
                        // store all the information in the database. 
                        
                        let downloadUrl = metadata?.downloadURL()?.absoluteString
                        
                        // get the name of the current user.
                        
                        self.ref = FIRDatabase.database().reference().child("Usersinfo").child((FIRAuth.auth()?.currentUser?.uid)!)
                        self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            let value = snapshot.value as? NSDictionary
                            let username = value?["name"] as! String
                            
                            // get the current number of posts so we can increment by 1.
                            
                            let numOfPosts = value?["numofposts"] as! Int
                            
                            if let url = downloadUrl, let postText = self.postTextView.text {
                                
                                let newPost = Post(_name: username, _imageurl: url, _posttext: postText, _user_id: (FIRAuth.auth()?.currentUser?.uid)!)
                                
                                let thePost: [String: AnyObject] = ["imageurl": newPost.imageurl as AnyObject, "name": newPost.name as AnyObject, "posttext": newPost.posttext as AnyObject, "user_id": newPost.user_id as AnyObject]
                                
                                
                                
                                
                                
                                self.postRef = FIRDatabase.database().reference().child("Posts").childByAutoId() // give a random id for the post.
                                
                                self.postRef.setValue(thePost, withCompletionBlock: { (error, postRef) in
                                    
                                    if error == nil {
                                        
                                        let myAlert = UIAlertController(title: "Success", message: "Your post has been successfully submitted", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (success) in
                                            
                                            
                                            self.tabBarController?.selectedIndex = 0 // show the home screen. tab bar with index 0.
                                            
                                            self.postTextView.text = ""
                                            self.removeButton.isEnabled = false
                                            self.postImage.image = UIImage(named: "imageplaceholder")
                                            self.publishButton.isEnabled = false
                                            self.publishButton.backgroundColor = UIColor.lightGray
                                            
                                            
                                            // now we need to increment the number of posts by 1.
                                            print("Current Number of posts is: \(numOfPosts)")
                                            
                                            let newNumberOfPosts = numOfPosts + 1
                                            
                                            self.ref.child("numofposts").setValue(newNumberOfPosts)
                                            
                                        })
                                        
                                        myAlert.addAction(okAction)
                                        self.present(myAlert, animated: true, completion: nil)
                                        
                                        
                                    }else {
                                        
                                        
                                        self.displayAlert(title: "Alert!", message: "Error submitting your post.")
                                    }
                                    
                                    spiningActivity?.hide(true)
                                    
                                })
                            }
                            
                        })
                        
                        
                        
                    }
                })
                
            }
            
        }
        
        
        
    }
    func displayAlert(title: String, message: String){
        
        
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        myAlert.addAction(okAction)
        present(myAlert, animated: true, completion: nil)
        
    }

}
