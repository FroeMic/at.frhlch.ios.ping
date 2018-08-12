//
//  ThemeProvider.swift
//  ping
//
//  Created by Michael Fröhlich on 02.07.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

protocol AppTheme {
    
    var name: String { get }
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
    var tintColor: UIColor { get }
    
    var navigationBarStyle: UIBarStyle { get }
    var statusBarStyle: UIStatusBarStyle { get }
    
}

extension AppTheme {
    
    var isPremiumTheme: Bool {
        
        let freeThemes: [String] = ["Dark", "Light"]
        
        if let _ = freeThemes.index(where: {$0 == name }) {
            return false
        }
        
        return true
    }
    
}
