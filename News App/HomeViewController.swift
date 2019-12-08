//
//  HomeViewController.swift
//  News App
//
//  Created by Hoang Pham on 12/5/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        //Load data from server

        loadNewsData("bbc-news")

    }

    func loadNewsData(_ source: String) {
        NewsAPIConfig.getNewsItems(source: source)
            .done { result in
                for article in result.articles{
                    print(article.title)
                }
                
                
            }
            .ensure(on: .main) {

            }.catch(on: .main) {
                err in print(err.localizedDescription) }
    }


}
