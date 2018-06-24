//
//  ICMPType.swift
//  ping
//
//  Created by Michael Fröhlich on 24.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

enum ICMPType: UInt8 {
    case EchoReply = 0
    case EchoRequest = 8
}
