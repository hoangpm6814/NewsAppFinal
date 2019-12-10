//
//  HomeViewController.swift
//  News App
//
//  Created by Hoang Pham on 12/5/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var newsTable: UITableView!
    var newsArray: [News] = []
    var newsToSend: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTable.delegate = self
        newsTable.dataSource = self

        //Load data from server

        loadNewsData("bbc-news")
        //loadNewsbySearching(with: "football")
    }

    func loadNewsData(_ source: String) {
        NewsAPIConfig.getNewsItems(source: source)
            .done { result in
                print(result)
                for article in result.articles {
                    print(article.title)
                    self.newsArray.append(article)
                    self.newsTable.reloadData()
                }


            }
            .ensure(on: .main) {

            }.catch(on: .main) {
                err in print(err.localizedDescription) }
    }
    
    func loadNewsbyTopic(_ params: SourcesRequestParameters) {
        NewsAPIConfig.getNewsSource(sourceRequestParams: params)
            .done { result in




            }
            .ensure(on: .main) {

            }.catch(on: .main) {
                err in print(err.localizedDescription)
        }
    }
    func loadNewsbySearching(with query: String) {
        NewsAPIConfig.searchNews(query: query)
            .done { result in
                for article in result.articles {
                    print(article.title)
                    
                }


            }
            .ensure(on: .main) {

            }.catch(on: .main) {
                err in print(err.localizedDescription)
                
        }
    }


}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           newsToSend = newsArray[indexPath.row]
           tableView.deselectRow(at: indexPath, animated: true)
           performSegue(withIdentifier: "showNewsDetail", sender: self)
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! NewsDetailViewController
        nextVC.news = newsToSend
    }

}
