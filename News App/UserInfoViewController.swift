//
//  UserInfoViewController.swift
//  News App
//
//  Created by Hoang Pham on 12/26/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserInfoViewController: UIViewController {
    @IBOutlet weak var userFirstName: UILabel!
    @IBOutlet weak var userLastName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    
    
    let user = Auth.auth().currentUser
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.userImage.image = UIImage(data: data)
            }
        }
    }
    
    func getUserInfo() {
        guard let user = user else { return }
        let db = Firestore.firestore()
        let email = user.email!
        let userDoc = db.collection("users").document(email)
        
        userDoc.getDocument { (document, error) in
            if let error = error {
                print("\(error)")
            } else {
                guard let firstName = document?.get("firstname") else { return }
                self.userFirstName.text = firstName as? String
                guard let lastName = document?.get("lastname") else { return }
                self.userLastName.text = lastName as? String
                guard let email = document?.get("email") else { return }
                self.userEmail.text = email as? String
                guard let imageURL = document?.get("photoURL") else { return }
                let url = URL(string: imageURL as! String)!
                self.downloadImage(from: url)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfo()
        
        navigationItem.title = "User's Infomation"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(signOutButtonTapped))
    }
    
    @objc func signOutButtonTapped() {
//        print("123")
        do {
            try Auth.auth().signOut()

            let viewController: UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "viewController") as! ViewController)
            self.navigationController?.pushViewController(viewController, animated: false)
            
        } catch let err {
            print(err)
        }

    }
}
