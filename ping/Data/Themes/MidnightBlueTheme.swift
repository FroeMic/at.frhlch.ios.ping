//
//  LightTheme.swift
//  ping
//
//  Created by Michael Fröhlich on 02.07.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class MidnightBlueTheme: ThemeProvider {
    
    let name: String = "Midnight Blue"
    let backgroundColor: UIColor = UIColor(red:0.00, green:0.16, blue:0.36, alpha:1.00)
    let textColor: UIColor = .white
    let tintColor: UIColor = UIColor(red:0.32, green:0.63, blue:0.34, alpha:1.00)
    
    let navigationBarStyle: UIBarStyle = .black
    let statusBarStyle: UIStatusBarStyle = .lightContent

}
