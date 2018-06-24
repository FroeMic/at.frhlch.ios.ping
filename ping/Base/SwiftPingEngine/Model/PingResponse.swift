//
//  PingResponse.swift
//  ping
//
//  Created by Michael Fröhlich on 24.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

public class PingResponse: NSObject {
    
    public var identifier: UInt32
    public var ipAddress: String?
    public var sequenceNumber: Int64
    public var duration: TimeInterval
    public var error: NSError?
    
    public init(id identifier: UInt32, ipAddress: String?, sequenceNumber: Int64, duration: TimeInterval, error: NSError?) {
        self.identifier = identifier
        self.ipAddress = ipAddress
        self.sequenceNumber = sequenceNumber
        self.duration = duration
        self.error = error
    }
    
}
