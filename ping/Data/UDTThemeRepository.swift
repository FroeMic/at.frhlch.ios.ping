//
//  UDTThemeRepository.swift
//  ping
//
//  Created by Michael Fröhlich on 06.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

class UDTThemeRepository: ThemeProvider {
    
    fileprivate let selectedThemeKey = "selectedTheme"
    fileprivate let defaults = UserDefaults.standard
    
    var selectedTheme: AppTheme {
        let themeName = defaults.string(forKey: selectedThemeKey) ?? ""
        
        let themes = get()
        guard let index = themes.index(where: { $0.name == themeName} ) else {
            return DarkTheme()
        }
        
        return themes[index]
        
    }
    
    func select(theme: AppTheme) {
        defaults.set(theme.name, forKey: selectedThemeKey)
    }
    
    func get() -> [AppTheme] {
        return [
            // dark themes
            DarkTheme(),
            ClassicNeoTheme(),
            BloodRedTheme(),
            BrutalRustTheme(),
            SolarBlueTheme(),
            MidnightBlueTheme(),
            
            // light themes
            LightTheme(),
            OrchidMildTheme(),
            LavenderChillTheme(),
        ]
    }
}
