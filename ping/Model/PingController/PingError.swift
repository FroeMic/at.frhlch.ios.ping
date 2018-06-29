//
//  PingError.swift
//  ping
//
//  Created by Michael Fröhlich on 28.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

enum PingError: Error {
    
    /**
     * Failed to resolve the specified host.
     */
    case failedToResolveHost
    
    /**
     * Failed to send the ping.
     */
    case failedToSendPing
    
    /**
     * Failed with a not further specified error.
     */
    case failedWithError
    
    /**
     * Received an unexpected reply from the host.
     */
    case receivedUnexpectedReply
    
    /**
     * The request timed out.
     */
    case didTimedOut
    
    
}
