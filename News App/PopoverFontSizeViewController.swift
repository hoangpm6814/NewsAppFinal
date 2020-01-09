//
//  PopoverFontSizeViewController.swift
//  News App
//
//  Created by I Am Focused on 1/10/20.
//  Copyright © 2020 LVHhcmus. All rights reserved.
//

import UIKit

protocol UpdatingFontSizeDelegate {
    func updateFontSize(_ FontSize: CGFloat)
}

class PopoverFontSizeViewController: UIViewController {

    var delegate: UpdatingFontSizeDelegate?



    @IBAction func increaseFontSizeTapped(_ sender: Any) {
        if Shared.shared.FontSize! <= 30 {
            Shared.shared.FontSize += 1
        }


//        print(Shared.shared.FontSize)
        delegate?.updateFontSize(Shared.shared.FontSize ?? 14)

    }


    @IBAction func decreaseFontSizeTapped(_ sender: Any) {
        if Shared.shared.FontSize! >= 5 {
            Shared.shared.FontSize -= 1
        }


        delegate?.updateFontSize(Shared.shared.FontSize ?? 14)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



}
