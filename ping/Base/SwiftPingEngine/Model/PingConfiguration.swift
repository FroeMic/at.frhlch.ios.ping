//
//  PingConfiguration.swift
//  ping
//
//  Created by Michael Fröhlich on 24.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

public class PingConfiguration: NSObject {
    
    /**
     * The ping interval. Default is 1 second.
     */
    let pingInterval: TimeInterval
    
    /**
     * The timeout interval. Default is 5 seconds.
     */
    let timeOutInterval: TimeInterval
    
    /**
     * The payload size. Default is 64 bytes.
     */
    let payloadSize: UInt64
    
    public init(pingInterval:TimeInterval = 1, timeOutInterval:TimeInterval = 5, payloadSize:UInt64 = 64) {
        self.pingInterval = pingInterval
        self.timeOutInterval = timeOutInterval
        self.payloadSize = payloadSize
    }
    
    
}
