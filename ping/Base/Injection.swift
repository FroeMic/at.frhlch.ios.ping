//
//  Injection.swift
//  ping
//
//  Created by Michael Fröhlich on 12.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

class Injection {

    static let hostRepository: HostHistoryRepository = UDTHostHistoryRepository()
    static let theme: ThemeProvider = LightTheme()
    
}
