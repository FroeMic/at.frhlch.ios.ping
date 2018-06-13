//
//  PingResponse.swift
//  ping
//
//  Created by Michael Fröhlich on 12.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

struct PingResult {
    
    let host: String
    let sizeInBytes: Int
    let sequence: Int
    let ttl: Int
    let timeInMs: Double
    let error: String?
    
    var description: String {
        if let error = error {
            return error
        } else {
            return String(format: "%d bytes from %@: icmp_seq=%ld ttl=%d time=%f ms",
                          sizeInBytes,
                          host,
                          sequence,
                          ttl,
                          timeInMs
            )
        }
    }
    
}
