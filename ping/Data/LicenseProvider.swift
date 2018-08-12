//
//  LicenseProvider.swift
//  ping
//
//  Created by Michael Fröhlich on 05.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

protocol LicenseProvider {
    
    var licenses: [License] { get }
    
}
