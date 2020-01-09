//
//  DFSafariViewController.swift
//  News App
//
//  Created by I Am Focused on 1/9/20.
//  Copyright © 2020 LVHhcmus. All rights reserved.
//

import UIKit
import SafariServices

class DFSafariViewController: SFSafariViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            self.preferredControlTintColor = .black
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
