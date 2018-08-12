//
//  File.swift
//  ping
//
//  Created by Michael Fröhlich on 05.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation


struct License {
    
    let title: String
    let url: String
    let license: String
    
    init(title: String, url: String, license: String) {
        self.title = title
        self.url = url
        self.license = license
    }
    
}
