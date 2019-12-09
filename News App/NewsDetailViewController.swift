//
//  NewsDetailViewController.swift
//  News App
//
//  Created by Hang Thanh on 12/9/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var newsContentTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customMenuSelectedText()
    }
    
    func customMenuSelectedText() {
        let highlightItem = UIMenuItem(title: "Highlight", action: #selector(highlightSelectedText))
        let translateItem = UIMenuItem(title: "Translate", action: #selector(translateSelectedText))
        UIMenuController.shared.menuItems = [highlightItem, translateItem]
    }
    
    @objc func highlightSelectedText() {
        if let range = newsContentTV.selectedTextRange, let selectedText = newsContentTV.text(in: range) {
            let string = NSMutableAttributedString(attributedString: newsContentTV.attributedText)
            let attributes = [NSAttributedString.Key.backgroundColor: UIColor.yellow]
            string.addAttributes(attributes, range: newsContentTV.selectedRange)
            newsContentTV.attributedText = string
           print(selectedText)
            //send data to highlight list
            //do something here
        }
    }
    
    @objc func translateSelectedText() {
        if let range = newsContentTV.selectedTextRange, let selectedText = newsContentTV.text(in: range) {
           print(selectedText)
            print("Translated")
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
