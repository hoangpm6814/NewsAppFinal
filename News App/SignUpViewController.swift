//
//  SignUpViewController.swift
//  News App
//
//  Created by Hoang Pham on 12/5/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorLbl.alpha = 0
    }
    

    func validateFields() -> String? {
       
       // Check that all fields are filled in
       if firstNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           lastNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
           
           return "Please fill in all data needed."
        
        }
       return nil
    }
    func showError(_ message:String) {
        
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
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    self.showError("Error creating!!!")
                }
                else {
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "uid": result!.user.uid ]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    
                    // Go to the home screen
                    let homeviewController:UIViewController =  (self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController)!
                     
                    self.navigationController?.pushViewController(homeviewController, animated: true)
                }
            }
        }
    }
}
