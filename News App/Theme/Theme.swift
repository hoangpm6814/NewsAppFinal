//
//  Theme.swift
//  News App
//
//  Created by Hoang Pham on 1/8/20.
//  Copyright © 2020 LVHhcmus. All rights reserved.
//

import UIKit

struct Theme {
    let textColor: UIColor
    let backgroundColor: UIColor
    
    static let light = Theme(textColor: .black, backgroundColor: UIColor(red: 255/255, green: 248/255, blue: 247/255, alpha: 1.0))
    static let dark = Theme(textColor: .white, backgroundColor: .darkGray)
}
