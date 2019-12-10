//
//  SearchViewController.swift
//  News App
//
//  Created by Hang Thanh on 12/10/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchResultTable: UITableView!
    var searchResultArr: [News] = []
    var newsToSend: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultTable.delegate = self
        searchResultTable.dataSource = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //loadNewsbySearching(with: "football")
        // Do any additional setup after loading the view.
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("changed")
        if searchTF.text != nil {
            loadNewsbySearching(with: searchTF.text!)
        }
    }
    
    func loadNewsbySearching(with query: String) {
        print("searching")
        searchResultArr.removeAll()
        searchResultTable.reloadData()
           NewsAPIConfig.searchNews(query: query)
               .done { result in
                   for article in result.articles {
                       print(article.title)
                       self.searchResultArr.append(article)
                       self.searchResultTable.reloadData()
                   }
               }
               .ensure(on: .main) {

               }.catch(on: .main) {
                   err in print(err.localizedDescription)
                   
           }
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return searchResultArr.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
            let article = searchResultArr[indexPath.row]
            cell.textLabel?.text = article.title
            cell.detailTextLabel?.text = article.author
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           newsToSend = searchResultArr[indexPath.row]
           tableView.deselectRow(at: indexPath, animated: true)
           performSegue(withIdentifier: "showNewsDetail", sender: self)
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! NewsDetailViewController
        nextVC.news = newsToSend
    }

}
