//
//  LaunchScreenViewController.swift
//  ping
//
//  Created by Michael Fröhlich on 11.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    private static let segueIdentifier = "showMainScreen"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performSegue(withIdentifier: LaunchViewController.segueIdentifier, sender: self)
    }
}

