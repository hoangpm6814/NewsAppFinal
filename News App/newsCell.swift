//
//  newsCell.swift
//  News App
//
//  Created by Hoang Pham on 1/9/20.
//  Copyright © 2020 LVHhcmus. All rights reserved.
//

import UIKit

class newsCell: UITableViewCell {
    @objc func enableDarkmode() {
        let theme = ThemeManager.currentTheme
        backgroundColor = theme.backgroundColor
        textLabel?.textColor = theme.textColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        ThemeManager.addDarkModeObserver(to: self, selector: #selector(enableDarkmode))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        backgroundColor = UIColor(red: 255/255, green: 248/255, blue: 247/255, alpha: 1.0)
        // Configure the view for the selected state
    }

}
