//
//  NewsDetailViewController.swift
//  News App
//
//  Created by Hang Thanh on 12/9/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseMLNLTranslate
import Social

class NewsDetailViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    let user = Auth.auth().currentUser
    var news: News?
    var highlight: [Highlight]?
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publishedAt: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsContentTV: UITextView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            newsTitle.text = news?.title
            author.text = news?.author
            publishedAt.text = news?.publishedAt
            newsDescription.text = news?.Description
            newsContentTV.text = news?.content
        loadImage(news?.urlToImage ?? "")
        
        if let highlight = highlight {
            let string = NSMutableAttributedString(attributedString: newsContentTV.attributedText)
            for i in highlight {
                let range = NSRange(location: i.range[0], length: i.range[1])
                let attributes = [NSAttributedString.Key.backgroundColor: UIColor.yellow]
                string.addAttributes(attributes, range: range)
            }
            newsContentTV.attributedText = string
        }

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
    
    @IBAction func saveNewsBtnTapped(_ sender: Any) {
        if let user = user {
                   let email = user.email!
                   let db = Firestore.firestore()
               
                   let newsToFirestore: [String: Any] = [
                    "title": news?.title ?? "",
                       "author": news?.author ?? NSNull(),
                       "Description": news?.Description ?? NSNull(),
                       "url": news?.url ?? NSNull(),
                       "urlToImage": news?.urlToImage ?? NSNull(),
                       "publishedAt": news?.publishedAt ?? NSNull(),
                       "content": news?.content ?? NSNull()
                   ]
                   
                   let userDoc = db.collection("users").document(email)
                   userDoc.updateData(["saved": FieldValue.arrayUnion([newsToFirestore])
                   ])
               }
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
            let location = newsContentTV.offset(from: newsContentTV.beginningOfDocument, to: range.start)
            let length = newsContentTV.offset(from: range.start, to: range.end)
            //send data to highlight list
            //do something here
            if let user = user {
                let email = user.email!
                let db = Firestore.firestore()
            
                let newsToFirestore: [String: Any] = [
                 "title": news?.title ?? "",
                    "author": news?.author ?? NSNull(),
                    "Description": news?.Description ?? NSNull(),
                    "url": news?.url ?? NSNull(),
                    "urlToImage": news?.urlToImage ?? NSNull(),
                    "publishedAt": news?.publishedAt ?? NSNull(),
                    "content": news?.content ?? NSNull()
                ]
                
                let highlight: [String: Any] = [
                    "newsURL": news?.url ?? "",
                    "range": [location, length],
                    "color": 1
                ]
                
                let userDoc = db.collection("users").document(email)
                userDoc.updateData(["highlighted.highlightNews": FieldValue.arrayUnion([newsToFirestore])
                ])
                userDoc.updateData(["highlighted.highlightContent": FieldValue.arrayUnion([highlight])
                ])
            }
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
            
            //MLNL translate
//            let options = TranslatorOptions(sourceLanguage: .en, targetLanguage: .vi)
//            let englishVietnameseTranslator = NaturalLanguage.naturalLanguage().translator(options: options)
//            let conditions = ModelDownloadConditions(
//                allowsCellularAccess: false,
//                allowsBackgroundDownloading: true
//            )
//            englishVietnameseTranslator.downloadModelIfNeeded(with: conditions) { error in
//                guard error == nil else {return}
//                //Model downloaded successfully. Okay to start translating
//            }
//            englishVietnameseTranslator.translate(selectedText) { translatedText, error in
//                guard error == nil, let translatedText = translatedText else {return}
//                print("update text")
//                header.text = "Translate Finished"
//                viText.text = translatedText
//                viText.sizeToFit()
//            }
            
            
            //yandex translator
            let trans = YandexTranslate()
            let textToTranslate = selectedText
            if textToTranslate.count != 0 {
                let dic = ["myData": textToTranslate, "request": "1"]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Request"), object: nil, userInfo: dic)
            
                trans.translate(phrase: textToTranslate, toLang: "vi"){
                    (String) in
                    // Getting the response from the completion handler into main thread
                    DispatchQueue.main.async {
                        let translatedText = String
                        let dic = ["myData": translatedText, "request": "0"]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Answer"), object: nil, userInfo: dic)

                       header.text = "Translate Finished"
                       viText.text = translatedText
                        viText.sizeToFit()
                    }
                }

//            textField.text = ""
//            self.Send.setImage(UIImage(named: "Mike"), for: .normal)
//            isRecordingButton = true
            }
            
            
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        //Alert
        let alert = UIAlertController(title: "Share", message: "Share the news to the world!", preferredStyle: .actionSheet)
        
        //First action
        let actionOne = UIAlertAction(title: "Share on Facebook", style: .default) { (action) in
            //Checking if user is connected to Facebook
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)
            {
                let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
                
                post.setInitialText("Test share function")
                let url = URL(string: self.news!.url!)
                post.add(url)
                
                self.present(post, animated: true, completion: nil)
                
            } else {self.showAlert(service: "Facebook")}
        }
        
        //Second action
        let actionTwo = UIAlertAction(title: "Share on Twitter", style: .default) { (action) in
            //Checking if user is connected to Facebook
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
            {
                let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                
                post.setInitialText("Test share function")
                let url = URL(string: self.news!.url!)
                post.add(url)
                // post.add(UIImage(named: "img.png"))
                
                self.present(post, animated: true, completion: nil)
                
            } else {self.showAlert(service: "Twitter")}
        }
        
        let actionThree = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Add action to action sheet
        alert.addAction(actionOne)
        alert.addAction(actionTwo)
        alert.addAction(actionThree)
        
        //Present alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(service:String)
    {
        let alert = UIAlertController(title: "Error", message: "You are not connected to \(service)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
