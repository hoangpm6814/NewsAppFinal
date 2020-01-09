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

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var tableView: UITableView!
    var newsArray: [News] = []
    var newsToSend: News?
    var allHighlight : [Highlight]?
    var highlightToSend : [Highlight]?
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        getSavedNews()
        getAllHighlightedContent()
        setUpView()
    }
    
    func setUpView() {
        ThemeManager.addDarkModeObserver(to: self, selector: #selector(enableDarkmode))
    }
    
    @objc func enableDarkmode() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        let theme = isDarkMode ? Theme.dark : Theme.light
        view.backgroundColor = theme.backgroundColor
        tableView.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.barTintColor = theme.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
    }
    
    func getSavedNews() {
        guard let user = user else { return }
        let db = Firestore.firestore()
        let email = user.email!
        let userDoc = db.collection("users").document(email)
        userDoc.getDocument { (document, error) in
            if let error = error {
                print("\(error)")
            } else {
                guard let data = document?.get("saved"), let jsonData = try? JSONSerialization.data(withJSONObject: data) else { return }
                let decoder = JSONDecoder()
                let news = try! decoder.decode([News].self, from: jsonData)
                self.newsArray = news
                self.tableView.reloadData()
            }
        }
    }
    
    func getRecentlyViewNews() {
        guard let user = user else { return }
        let db = Firestore.firestore()
        let email = user.email!
        let userDoc = db.collection("users").document(email)
        userDoc.getDocument { (document, error) in
            if let error = error {
                print("\(error)")
            } else {
                guard let data = document?.get("recentlyView"), let jsonData = try? JSONSerialization.data(withJSONObject: data) else { return }
                let decoder = JSONDecoder()
                let news = try! decoder.decode([News].self, from: jsonData)
                self.newsArray = news
                self.tableView.reloadData()
            }
        }
    }
    
    func getHighlightedNews() {
        guard let user = user else { return }
        let db = Firestore.firestore()
        let email = user.email!
        let userDoc = db.collection("users").document(email)
        userDoc.getDocument { (document, error) in
            if let error = error {
                print("\(error)")
            } else {
                guard let data = document?.get("highlighted.highlightNews"), let jsonData = try? JSONSerialization.data(withJSONObject: data) else { return }
                let decoder = JSONDecoder()
                let news = try! decoder.decode([News].self, from: jsonData)
                self.newsArray = news
                self.tableView.reloadData()
            }
        }
    }
    
    func getAllHighlightedContent() {
        guard let user = user else { return }
        let db = Firestore.firestore()
        let email = user.email!
        let userDoc = db.collection("users").document(email)
        userDoc.getDocument { (document, error) in
            if let error = error {
                print("\(error)")
            } else {
                guard let data = document?.get("highlighted.highlightContent"), let jsonData = try? JSONSerialization.data(withJSONObject: data) else { return }
                let decoder = JSONDecoder()
                self.allHighlight = try! decoder.decode([Highlight].self, from: jsonData)
            }
        }
    }
    
    @IBAction func showSavedNews(_ sender: UIBarButtonItem) {
        getSavedNews()
    }
    
    @IBAction func showRecentlyViewNews(_ sender: UIBarButtonItem) {
        getRecentlyViewNews()
    }
    
    @IBAction func showHighlightedNews(_ sender: UIBarButtonItem) {
        getHighlightedNews()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! newsCell
        let article = newsArray[indexPath.row]
        cell.textLabel?.text = article.title
        cell.detailTextLabel?.text = article.author
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           newsToSend = newsArray[indexPath.row]
            highlightToSend = allHighlight?.filter {$0.newsURL == newsArray[indexPath.row].url}
           tableView.deselectRow(at: indexPath, animated: true)
           performSegue(withIdentifier: "showNewsDetail", sender: self)
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! NewsDetailViewController
        nextVC.news = newsToSend
        nextVC.highlight = highlightToSend
    }
}
