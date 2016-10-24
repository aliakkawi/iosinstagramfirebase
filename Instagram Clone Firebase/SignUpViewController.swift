//
//  SignUpViewController.swift
//  Instagram Clone Firebase
//
//  Created by Ali Akkawi on 10/17/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    // reset default size.
    var scrollViewHeight: CGFloat = 0
    var keyBoard = CGRect()
    
    
    @IBOutlet weak var profileImage: CustomImageView!
    @IBOutlet weak var emailTextField: MaterialTextField!
    
    @IBOutlet weak var passwordTextField: MaterialTextField!
    
    @IBOutlet weak var repeatePasswordTextField: MaterialTextField!
    
    @IBOutlet weak var fullnameTextField: MaterialTextField!
    
    let storage = FIRStorage.storage()
    var dbRef: FIRDatabaseReference!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func profileImageTapped(_ sender: AnyObject) {
        
        print("Image tapped")
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        myPickerController.allowsEditing = true
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profileImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    //when we touch the white area the keyboard disappears.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        repeatePasswordTextField.resignFirstResponder()
        fullnameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        
        return false
    }
    
    
    @IBAction func scrollViewTouched(_ sender: AnyObject) {
        
        self.view.endEditing(true)
    }
    
    
    
    
    
    
    @IBAction func signUpTapped(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        
        if let email = emailTextField.text, let password = passwordTextField.text, let repeatePassword = repeatePasswordTextField.text, let fullName = fullnameTextField.text {
            
            
            if email == "" || password == "" || repeatePassword == "" || fullName == "" {
                
                
                displayAlert(title: "Alert!", message: "Please fill in all fields")
                return
            }else if password != repeatePassword {
                
                
                displayAlert(title: "Alert!", message: "Password don't match")
                return
                
            }else {
                
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    
                    if error == nil {
                        
                        //save the profile image for the user.
                        
                        
                        if let theProfileImage = self.profileImage.image {
                            
                            if theProfileImage == UIImage(named: "profileimage"){ // the user didn't pick up an image.
                                
                                let newUser = User(_name: fullName, _profileimage: "")
                                
                                let theNewUser : [String: AnyObject] = ["name": newUser.name as AnyObject, "numoffollowers": newUser.numoffollowers as AnyObject, "numoffollowing": newUser.numoffollowing as AnyObject, "numofposts": newUser.numofposts as AnyObject, "profileimage": newUser.profileimage as AnyObject]
                                
                                self.dbRef = FIRDatabase.database().reference().child("Usersinfo").childByAutoId()
                                self.dbRef.setValue(theNewUser)
                                self.performSegue(withIdentifier: "gohomeup", sender: nil)
                                
                            }else { // the user pick up an image.
                                
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
                                            
                                            // store the image url and all the users's data in the database.
                                            
                                            
                                            // we need the url for the uploaded image so we can add it to the post class.
                                            
                                            let downloadUrl = metadata?.downloadURL()?.absoluteString
                                            
                                            if let url = downloadUrl {
                                                
                                                let newUser = User(_name: fullName, _profileimage: url)
                                                
                                                let theNewUser : [String: AnyObject] = ["name": newUser.name as AnyObject, "numoffollowers": newUser.numoffollowers as AnyObject, "numoffollowing": newUser.numoffollowing as AnyObject, "numofposts": newUser.numofposts as AnyObject, "profileimage": newUser.profileimage as AnyObject]
                                                
                                                self.dbRef = FIRDatabase.database().reference().child("Usersinfo").child((FIRAuth.auth()?.currentUser?.uid)!)
                                                self.dbRef.updateChildValues(theNewUser)//setValue(theNewUser)
                                                
                                                let successAlert = UIAlertController(title: "Success", message: "Successfully signed up", preferredStyle: .alert)
                                                let okAction = UIAlertAction(title: "oK", style: .default, handler: { (action) in
                                                    
                                                    self.performSegue(withIdentifier: "gohomeup", sender: nil)
                                                })
                                                
                                                successAlert.addAction(okAction)
                                                self.present(successAlert, animated: true, completion: nil)
                                                
                                                
                                                
                                                
                                            }
                                            
                                            
                                            
                                            
                                        }
                                    })
                                }
                                
                                
                                
                                
                            }
                            
                            
                        }
                        
                        
                    }else {
                        
                        self.displayAlert(title: "Alert", message: (error?.localizedDescription)!)
                        
                    }
                    
                    
                    
                })
                
            }
            
            
            
            
            
        }else {
            
            
            print("No data are found!!!")
        }
        
        
        
        
        
        
        
        
    }
    
    func displayAlert(title: String, message: String){
        
        
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        myAlert.addAction(okAction)
        present(myAlert, animated: true, completion: nil)
        
    }
    
    
    
    
}
