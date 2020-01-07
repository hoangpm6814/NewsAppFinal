//
//  ThemeManager.swift
//  News App
//
//  Created by Hoang Pham on 1/8/20.
//  Copyright © 2020 LVHhcmus. All rights reserved.
//

import UIKit

struct ThemeManager {
    static let isDarkModeKey = "isDarkMode"
    
    static var currentTheme: Theme {
        return isDarkMode() ? .dark : .light
    }
    
    static func isDarkMode() -> Bool {
        return UserDefaults.standard.bool(forKey: isDarkModeKey)
    }
    
    static func enableDarkMode() {
        UserDefaults.standard.set(true, forKey: isDarkModeKey)
        NotificationCenter.default.post(name: .darkModeHasChanged, object: nil)
    }
    
    static func disableDarkMode() {
        UserDefaults.standard.set(false, forKey: isDarkModeKey)
        NotificationCenter.default.post(name: .darkModeHasChanged, object: nil)
    }
    static func addDarkModeObserver(to observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .darkModeHasChanged, object: nil)
    }
}

extension Notification.Name {
    static let darkModeHasChanged = Notification.Name("darkModeHasChanged")
}
