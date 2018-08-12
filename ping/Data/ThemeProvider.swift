//
//  ThemeProvider.swift
//  ping
//
//  Created by Michael Fröhlich on 06.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

protocol ThemeProvider {
    
    var selectedTheme: AppTheme { get }
    
    func select(theme: AppTheme)
    
    func get() -> [AppTheme]
    
}
