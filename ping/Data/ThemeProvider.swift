//
//  ThemeProvider.swift
//  ping
//
//  Created by Michael Fröhlich on 02.07.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

protocol ThemeProvider {
    
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
    var tintColor: UIColor { get }
    
    var statusBarStyle: UIStatusBarStyle { get }
    
}
