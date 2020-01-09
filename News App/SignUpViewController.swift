//
//  SignUpViewController.swift
//  News App
//
//  Created by Hoang Pham on 12/5/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Firebase

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        errorLbl.alpha = 0
        
        
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        signUpButton.layer.cornerRadius = 20.0
        // Image:
        
        // Tap to imageview
        let tapGestureToImageView = UITapGestureRecognizer(target: self, action: #selector(tapToImageView(sender:)))
        tapGestureToImageView.numberOfTapsRequired = 1 // So lan cham
        profileImageView?.isUserInteractionEnabled = true
        profileImageView?.addGestureRecognizer(tapGestureToImageView)
    }
    
    @objc func tapToImageView(sender: UITapGestureRecognizer){
        print("Tapped!")
        // Choose an image:
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary;
        self.present(pickerController, animated: true, completion: nil) // sau khi present ko làm gì ==> completion nil
    }
    
    // After choosing image, got image, to get it, implement this func:
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[.editedImage] as! UIImage
        profileImageView!.image = chosenImage // define image in
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }

        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {

                storageRef.downloadURL { url, error in
                    completion(url)
                    // success!
                }
            } else {
                    // failed
                    completion(nil)
            }
        }
        
    }
    
    func saveProfile(email:String, profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        let db = Firestore.firestore()
        let userDoc = db.collection("users").document(email)
        userDoc.updateData(["photoURL": profileImageURL.absoluteString])
    }

    
    func isCheckedPassword(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all data needed."
            
        }
        // Check if the password is secure
        let pass = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isCheckedPassword(pass) == false {
            // Password isn't secure enough
            return "Password at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    func showError(_ message: String) {
        
        errorLbl.text = message
        errorLbl.alpha = 1
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }
        else {
            // Create cleaned versions of the data
            let firstName = firstNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let image = profileImageView.image else { return }
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    self.showError("Error creating!!!")
                }
                else {
                    let db = Firestore.firestore()
                    db.collection("users").document(email).setData(["firstname": firstName, "lastname": lastName, "email": email, "password": password, "uid": result!.user.uid], merge: true) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    
                    // 1. Upload the profile image to Firebase Storage
                    
                    self.uploadProfileImage(image) { url in
                        if url != nil {
                            self.saveProfile(email: email, profileImageURL: url!) { success in
                                if success {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        } else {
                            // Error unable to upload profile image
                        }
                        
                    }
                    
                    // Go to tabBar
                    let tabBarController: UITabBarController = (self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController)
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                }
            }
        }
    }
}
