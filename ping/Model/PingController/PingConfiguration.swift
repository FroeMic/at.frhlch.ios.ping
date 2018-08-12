//
//  PingConfiguration.swift
//  ping
//
//  Created by Michael Fröhlich on 28.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

struct PingConfiguration {
    
    private static let timeOutKey: String = "timout"
    private static let frequencyKey: String = "frequency"
    private static let ttlKey: String = "ttl"
    private static let payloadKey: String  = "payload"
    
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
    
    init?(dict: Dictionary<String, String>) {
        
        guard dict.keys.contains(PingConfiguration.timeOutKey),
            dict.keys.contains(PingConfiguration.frequencyKey),
            dict.keys.contains(PingConfiguration.ttlKey),
            dict.keys.contains(PingConfiguration.payloadKey)else {
                return nil
        }
        guard let timeoutString = dict[PingConfiguration.timeOutKey], let timeout = TimeInterval(timeoutString) else {
            return nil
        }
        guard let frequencyString = dict[PingConfiguration.frequencyKey], let frequency = TimeInterval(frequencyString) else {
            return nil
        }
        guard let ttlString = dict[PingConfiguration.ttlKey], let ttl = UInt8(ttlString) else {
            return nil
        }
        guard let payloadString = dict[PingConfiguration.payloadKey], let payload = UInt8(payloadString) else {
            return nil
        }
        
        self.init(timeout: timeout, frequency: frequency, ttl: ttl, payload: payload)
    }
    
    func toDict() -> Dictionary<String, String> {
        return [
            PingConfiguration.timeOutKey: String(format: "%.1f", self.timeout),
            PingConfiguration.frequencyKey: String(format: "%.1f", self.frequency),
            PingConfiguration.ttlKey: String(format: "%u", self.ttl),
            PingConfiguration.payloadKey: String(format: "%u", self.payload)
        ]
    }
    
}
