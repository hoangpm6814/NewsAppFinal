//
//  HomeViewController.swift
//  News App
//
//  Created by Hoang Pham on 12/5/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var newsTable: UITableView!
    var newsArray: [News] = []
    var newsToSend: News?

    let user = Auth.auth().currentUser

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        newsTable.delegate = self
//        newsTable.dataSource = self
//
//        //Load data from server
//
//        loadNewsData("bbc-news")
//        //loadNewsbySearching(with: "football")
//        setUpView()
//
//
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func loadView() {
        super.loadView()
        newsTable.delegate = self
        newsTable.dataSource = self

        //Load data from server

        loadNewsData("bbc-news")
        //loadNewsbySearching(with: "football")
        setUpView()
    }

    func setUpView() {
        ThemeManager.addDarkModeObserver(to: self, selector: #selector(enableDarkmode))
    }

    @objc func enableDarkmode() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        let theme = isDarkMode ? Theme.dark : Theme.light
        view.backgroundColor = theme.backgroundColor
        newsTable.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.barTintColor = theme.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
    }

    func loadNewsData(_ source: String) {
        NewsAPIConfig.getNewsItems(source: source)
            .done { result in
                //print(result)
                for article in result.articles {
                    //print(article.title)
                    self.newsArray.append(article)
                    self.newsTable.reloadData()
                }


            }
            .ensure(on: .main) {

            }.catch(on: .main) {
                err in print(err.localizedDescription) }
    }

    func loadNewsDatabyTopic(_ category: String) {
        NewsAPIConfig.getNewsItemsbyTopic(category: category)
            .done { result in
                //print(result)
                if(!self.newsArray.isEmpty) {
                    self.newsArray.removeAll()
                }

                for article in result.articles {
                    //print(article.title)
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
    func loadImage(_ imgView: UIImageView, _ imageURL: String) {
        guard let objURL = URL(string: imageURL) else { return }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: objURL) { (data, response, error) in
            if error != nil {
                print("Error")
            } else {
                DispatchQueue.main.async {
                    imgView.image = UIImage(data: data!)
                }
            }
        }
        dataTask.resume()
    }

//    MARK: - Action Button Filter

    @IBAction func filterTapped(_ sender: Any) {


        let vc = storyboard?.instantiateViewController(withIdentifier: "PopoverFilterViewController")as! PopoverFilterViewController

        vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        vc.delegateToGetCategory = self

        let navController = UINavigationController(rootViewController: vc)
        vc.navigationController?.isNavigationBarHidden = true
        navController.modalPresentationStyle = UIModalPresentationStyle.popover

        let popover = navController.popoverPresentationController
        popover?.delegate = self as? UIPopoverPresentationControllerDelegate
        popover?.barButtonItem = sender as? UIBarButtonItem


        self.present(navController, animated: true, completion: nil)



    }




}
//    MARK: - delegate to get category
extension HomeViewController: getCategoryNewsDelegate {
    func getCategory(_ category: String) {
        //Load data from server
        loadNewsDatabyTopic(category)
        //loadNewsbySearching(with: "football")
        setUpView()
    }


}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! newsCell
        let article = newsArray[indexPath.row]
//            cell.textLabel?.text = article.title
//            cell.detailTextLabel?.text = article.author


//        cell.imageNews?.image = article.urlToImage
        cell.titleLabel?.text = article.title
        cell.sourceLabel?.text = article.author
//        loadImage(cell.imageView!, article.urlToImage ?? "")


//        MARK: - load image
        let objURL = URL(string: article.urlToImage ?? "https://bitsofco.de/content/images/2018/12/broken-1.png")
        let otherURL = URL(string: "https://bitsofco.de/content/images/2018/12/broken-1.png")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: objURL ?? otherURL!) { (data, response, error) in
            if error != nil {
                print("Error")
            } else {
                DispatchQueue.main.async {
                    cell.imageNews.image = UIImage(data: data!)
                }
            }
        }
        dataTask.resume()









//            let theme = Theme.dark
//            cell.backgroundColor = theme.backgroundColor
//            cell.textLabel?.textColor = theme.textColor
        /////
//            let name = Notification.Name("darkModeHasChanged")
//            NotificationCenter.default.addObserver(self, selector: #selector(enableDarkmode2), name: name, object: nil)
        return cell
    }
    //////
//    @objc func enableDarkmode2() {
//        let theme = Theme.dark
//
//        backgroundColor = theme.backgroundColor
//        textLabel?.textColor = theme.textColor
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = user {
            let email = user.email!
            let db = Firestore.firestore()

            let newsToFirestore: [String: Any] = [
                "title": newsArray[indexPath.row].title,
                "author": newsArray[indexPath.row].author ?? NSNull(),
                "Description": newsArray[indexPath.row].Description ?? NSNull(),
                "url": newsArray[indexPath.row].url ?? NSNull(),
                "urlToImage": newsArray[indexPath.row].urlToImage ?? NSNull(),
                "publishedAt": newsArray[indexPath.row].publishedAt ?? NSNull(),
                "content": newsArray[indexPath.row].content ?? NSNull()
            ]

            let userDoc = db.collection("users").document(email)
            userDoc.updateData(["recentlyView": FieldValue.arrayUnion([newsToFirestore])
            ])
        }
        newsToSend = newsArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showNewsDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! NewsDetailViewController
        nextVC.news = newsToSend
    }

}

