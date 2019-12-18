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
                    //                    db.collection("users").addDocument(data: ["firstname": firstName, "lastname": lastName, "email": email, "password": password, "uid": result!.user.uid]) { (error) in
                    //
                    //                        if error != nil {
                    //                            // Show error message
                    //                            self.showError("Error saving user data")
                    //                        }
                    //                    }
                    
                    
                    // Go to the home screen
                    //                    let loginViewController: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! LoginViewController
                    //                    self.navigationController?.pushViewController(loginViewController, animated: true)
                    let tabBarController: UITabBarController = (self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController)
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                    
                }
            }
        }
    }
}
