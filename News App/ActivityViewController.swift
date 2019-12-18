//
//  ActivityViewController.swift
//  News App
//
//  Created by Hang Thanh on 12/18/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import UIKit
import Firebase

class ActivityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var newsArray: [News] = []
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showSavedNews(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func showRecentlyViewNews(_ sender: UIBarButtonItem) {
//        guard let user = user else { return }
//        let db = Firestore.firestore()
//        let email = user.email!
//        let userDoc = db.collection("users").document(email)
//        userDoc.getDocument { (document, error) in
////            let result = Result {
////                try document?.get("recentlyView").flatMap {
////                    try $0.data(as: News.self)
////                }
////            }
////            switch result {
////            case .success(let city):
////                if let city = city {
////                    print("City: \(city)")
////                } else {
////                    print("Document does not exist")
////                }
////            case .failure(let error):
////                print("Error decoding city: \(error)")
////            }
//
//            if let error = error {
//                print("\(error)")
//            } else {
//                guard let data = document?.get("recentlyView"), var jsonData = try? JSONSerialization.data(withJSONObject: data) else { return }
//
//
//                //let jsonData = data.data(using: String.Encoding.utf8)!
//                let decoder = JSONDecoder()
//                let news = try! decoder.decode([News].self, from: jsonData)
//                print(news[0])
//                self.newsArray = news
//                self.tableView.reloadData()
//            }
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
        let article = newsArray[indexPath.row]
        cell.textLabel?.text = article.title
        cell.detailTextLabel?.text = article.author
        return cell
    }
}
