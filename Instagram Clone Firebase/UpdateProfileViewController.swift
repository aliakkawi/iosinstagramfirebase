//
//  UpdateProfileViewController.swift
//  Instagram Clone Firebase
//
//  Created by Ali Akkawi on 22/10/2016.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit
import Firebase

class UpdateProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    var originalName = ""
    var originalEmail = ""
    var pickNewProfileImage = false
    
    var usersInfoRef: FIRDatabaseReference!
    let storage = FIRStorage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // query the Usersinfo.
        
        let firRef = FIRDatabase.database().reference()
        
        let currentUsrId = FIRAuth.auth()?.currentUser?.uid
        
        print("Current user id: \(currentUsrId!)")
        usersInfoRef = firRef.child("Usersinfo").child(currentUsrId!)
        
        usersInfoRef.observe(.value, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! [String: AnyObject]
            
            let currentUserName = snapshotValue["name"] as! String
            let currentUserProfileImage = snapshotValue["profileimage"] as! String
            
            
        
            
            self.nameTextField.text = currentUserName
            self.emailTextField.text = FIRAuth.auth()?.currentUser?.email
            
            
            // download the profile image.
            
            
            self.profileImageView.sd_setImage(with: URL(string: currentUserProfileImage), placeholderImage: #imageLiteral(resourceName: "profileimage"), options: [.continueInBackground, .progressiveDownload])
            
            
            if let theOriginalName = self.nameTextField.text, let theOriginalEmail = FIRAuth.auth()?.currentUser?.email {
                
                self.originalName = theOriginalName
                self.originalEmail = theOriginalEmail
                
                
            }

        })
    }
    
    
    
    @IBAction func profileImageTapped(_ sender: AnyObject) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        myPickerController.allowsEditing = true
        self.present(myPickerController, animated: true, completion: nil)
        
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        profileImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        pickNewProfileImage = true
        self.dismiss(animated: true, completion: nil)
    
    }

    
    @IBAction func saveTapped(_ sender: AnyObject) {
        
        if let theName = self.nameTextField.text, let theEmail = emailTextField.text {
            
            if theName == "" || theEmail == "" {
                
                
                displayAlert(title: "Alert", message: "Please fill in fields")
                return
            }
            
            else {
                
                let myAlert = UIAlertController(title: "Sure?", message: "Are you sure you want to change profile?", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (okaction) in
                    
                    
                    self.updateEmailAndName(name: theName, email: theEmail)
                    
                    
                    // the user picked a new image. 
                    
                    
                    if self.pickNewProfileImage {
                     
                        
                        if let theProfileImage = self.profileImageView.image {
                            
                            if let imageData = UIImageJPEGRepresentation(theProfileImage, 0.2){
                                
                                // uniqu id for the image
                                let imgUid = NSUUID().uuidString
                                
                                // we have to inform firebase storage that we are dealing with jpeg
                                let metadata = FIRStorageMetadata()
                                metadata.contentType = "image/jpeg"
                                
                                // upload the image
                                
                                let usersStorageReference = self.storage.reference().child("profileimages").child(imgUid)
                                
                                usersStorageReference.put(imageData, metadata: metadata, completion: { (metadata, error) in
                                    
                                    if error != nil{
                                        
                                        
                                        print("Unable to upload profile image")
                                    }else {
                                        
                                        
                                        let downloadUrl = metadata?.downloadURL()?.absoluteString
                                        
                                        if let url = downloadUrl {
                                            let newProfileImage = ["profileimage": url]
                                            self.usersInfoRef.updateChildValues(newProfileImage)//.setValue(url)
                                            
                                        }
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                })
                                
                                
                                
                            }
                            
                        }
                     
                        
                    }
                    
                    
                    // get back .
                    self.performSegue(withIdentifier: "backtomain", sender: nil)
                    
                    
                    
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                myAlert.addAction(okAction)
                myAlert.addAction(cancelAction)
                present(myAlert, animated: true, completion: nil)
            }
            
            
        }
        
        
    }
    
    
    func updateEmailAndName (name: String, email: String){
        
        // update the name.
        
        // it is recomender to user updatechildvalues rather than setting a new value.
        let newname = ["name": name]
        usersInfoRef.updateChildValues(newname)
        
        // update the Email.
        
        let user = FIRAuth.auth()?.currentUser
        
        user?.updateEmail(email) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Email address updated.")
            }
        }
        
    }
    
    
    //when we touch the white area the keyboard disappears.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        return false
    }
    
    
    
    
    
    func displayAlert(title: String, message: String){
        
        
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        myAlert.addAction(okAction)
        present(myAlert, animated: true, completion: nil)
        
    }

}
