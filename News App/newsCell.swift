//
//  newsCell.swift
//  News App
//
//  Created by Hoang Pham on 1/9/20.
//  Copyright © 2020 LVHhcmus. All rights reserved.
//

import UIKit

class newsCell: UITableViewCell {
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//
//        ThemeManager.addDarkModeObserver(to: self, selector: #selector(enableDarkmode))
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
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

        // Configure the view for the selected state
    }

}
