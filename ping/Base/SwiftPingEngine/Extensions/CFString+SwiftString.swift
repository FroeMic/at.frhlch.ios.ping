//
//  CFString+SwiftString.swift
//  ping
//
//  Created by Michael Fröhlich on 24.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

extension CFString {
    
    var asString: String {
        let nsTypeString = self as NSString
        let swiftString: String = nsTypeString as String
        return swiftString
    }
    
}


extension String {
    
    var asCFString: CFString {
        let nsTypeString: NSString =  self as NSString
        let cfTypeString: CFString = nsTypeString as CFString
        return cfTypeString
    }
    
}
