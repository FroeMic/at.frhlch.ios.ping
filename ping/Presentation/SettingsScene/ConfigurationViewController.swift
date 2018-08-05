//
//  ConfigurationViewController.swift
//  ping
//
//  Created by Michael Fröhlich on 05.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController {
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Configuration"
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyTheme()
        
        // Show the Navigation Bar
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func applyTheme() {
        let theme = Injection.theme
        
        navigationController?.navigationBar.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.barStyle = theme.navigationBarStyle
        navigationController?.navigationBar.tintColor = theme.textColor
        
        view.backgroundColor = theme.backgroundColor
    }
    
}
