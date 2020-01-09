//
//  ViewController.swift
//  News App
//
//  Created by I Am Focused on 11/29/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signUpButton.layer.cornerRadius = 20.0
        loginButton.layer.cornerRadius = 20.0
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }


}

