//
//  PingConfiguration.swift
//  ping
//
//  Created by Michael Fröhlich on 28.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

struct PingConfiguration {
    
    /**
     * The timeout interval in seconds.
     * Default is 5.0 seconds.
     */
    let timeout: TimeInterval
    
    /**
     * The ping frequency in seconds.
     * Default is 1.0 seconds.
     */
    let frequency: TimeInterval
    
    /**
     * The time to live (ttl) for the sent ping.
     * Default is 64.
     */
    let ttl: UInt8
    
    /**
     * The ping payload size in bytes.
     * Default is 56 bytes.
     */
    let payload: UInt8
    
    init(timeout: TimeInterval = 5.0, frequency: TimeInterval = 1.0, ttl: UInt8 = 64, payload: UInt8 = 56) {
        self.timeout = timeout
        self.frequency = frequency
        self.ttl = ttl
        self.payload = payload
    }
    
}
