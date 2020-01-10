//
//  LoginViewController.swift
//  News App
//
//  Created by Hoang Pham on 12/5/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorLbl.alpha = 0
        emailTF.layer.cornerRadius = 20.0
        passwordTF.layer.cornerRadius = 20.0
        loginButton.layer.cornerRadius = 20.0
    }

    @IBAction func LoginButton(_ sender: Any) {
        setupSpinner()
        spinningActivityIndicator.start()
        let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)


        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorLbl.text = error!.localizedDescription
                self.errorLbl.alpha = 1
            }
            else {
                self.spinningActivityIndicator.stop()
                let tabBarController: UITabBarController = (self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController)
                self.navigationController?.pushViewController(tabBarController, animated: true)
                self.navigationController?.isNavigationBarHidden = true
            }
        }
    }
    //    MARK: - Spinner Setting
    let spinningActivityIndicator = TSSpinnerView()
    //    MARK: - Setup Spinner

    func setupSpinner() {
        spinningActivityIndicator.setupTSSpinnerView()
    }

}
