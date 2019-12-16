//
//  NewsDetailViewController.swift
//  News App
//
//  Created by Hang Thanh on 12/9/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMLNLTranslate

class NewsDetailViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    var news: News?
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publishedAt: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsContentTV: UITextView!
    
    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            newsTitle.text = news?.title
            author.text = news?.author
            publishedAt.text = news?.publishedAt
            newsDescription.text = news?.Description
            newsContentTV.text = news?.content
        loadImage(news?.urlToImage ?? "")
        
        

        // Do any additional setup after loading the view.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapView))
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
        view.addSubview(scrollView)
        customMenuSelectedText()
    }
    
    func loadImage(_ imageURL: String) {
        guard let objURL = URL(string: imageURL) else { return }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: objURL) { (data, response, error) in
            if error != nil {
                print("Error")
            }else{
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data!)
                }
            }
        }
        dataTask.resume()
    }
    
    @IBAction func readMoreBtnTapped(_ sender: Any) {
        
    }
    
    
    @objc func tapView() {
        scrollView.isHidden = true
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
            
            let screensize: CGRect = self.view.bounds
            let screenWidth = screensize.width
            let screenHeight = screensize.height
            
            scrollView = UIScrollView(frame: CGRect(x: 0, y: screenHeight*2/3, width: screenWidth, height: screenHeight*1/3))
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
            scrollView.backgroundColor = UIColor.systemGray5
            
            let header = UILabel(frame: CGRect(x: 10, y: 50, width: screenWidth - 20, height: 21))
            header.text = "Translating..."
            header.textAlignment = .center
            
            let enText = UILabel(frame: CGRect(x: 10, y: 100, width: screenWidth - 20, height: 21))
            enText.text = selectedText
            enText.numberOfLines = 0
            enText.sizeToFit()
            
            let viText = UILabel(frame: CGRect(x: 10, y: 110 + enText.frame.size.height, width: screenWidth - 20, height: 21))
            viText.text = "Loading..."
            viText.numberOfLines = 0
            
            scrollView.addSubview(header)
            scrollView.addSubview(enText)
            scrollView.addSubview(viText)
            self.view.addSubview(scrollView)
            
            let options = TranslatorOptions(sourceLanguage: .en, targetLanguage: .vi)
            let englishVietnameseTranslator = NaturalLanguage.naturalLanguage().translator(options: options)
            let conditions = ModelDownloadConditions(
                allowsCellularAccess: false,
                allowsBackgroundDownloading: true
            )
            englishVietnameseTranslator.downloadModelIfNeeded(with: conditions) { error in
                guard error == nil else {return}
                //Model downloaded successfully. Okay to start translating
            }
            englishVietnameseTranslator.translate(selectedText) { translatedText, error in
                guard error == nil, let translatedText = translatedText else {return}
                print("update text")
                header.text = "Translate Finished"
                viText.text = translatedText
                viText.sizeToFit()
            }
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
