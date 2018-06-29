//
//  PingResponse.swift
//  ping
//
//  Created by Michael Fröhlich on 12.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

struct PingResult {
    
    let status: PingStatus
    let host: String
    let ip: String
    let sizeInBytes: Int
    let sequence: Int
    let ttl: Int
    let timeInMs: Double
    
    var description: String {
        return String(format: "%d bytes from %@: icmp_seq=%ld ttl=%d time=%f ms",
                      sizeInBytes,
                      ip,
                      sequence,
                      ttl,
                      timeInMs
        )
    }
    
}
