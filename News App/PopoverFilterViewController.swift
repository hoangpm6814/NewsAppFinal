//
//  PopoverFilterViewController.swift
//  News App
//
//  Created by I Am Focused on 1/10/20.
//  Copyright © 2020 LVHhcmus. All rights reserved.
//

import UIKit
protocol getCategoryNewsDelegate {
    func getCategory(_ category: String)
}


class PopoverFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegateToGetCategory: getCategoryNewsDelegate?


    @IBOutlet weak var Popupview: UIView!


    @IBOutlet weak var tableView: UITableView!

    var names: [String] = ["Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

//       // Apply radius to Popupview
//        Popupview.layer.cornerRadius = 10
//        Popupview.layer.masksToBounds = true

    }


    // Returns count of items in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }


    // Select item from tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        delegateToGetCategory?.getCategory(names[indexPath.row])

        dismiss(animated: true, completion: nil)
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        self.present(newViewController, animated: true, completion: nil)


    }

    //Assign values for tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        cell.textLabel?.text = names[indexPath.row]

        return cell
    }

    // Close PopUp
    @IBAction func closePopup(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }



}



