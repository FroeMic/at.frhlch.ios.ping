//
//  SwiftPingEngineDelegate.swift
//  ping
//
//  Created by Michael Fröhlich on 24.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

public protocol SwiftPingEngineDelegate {
    
    func receivedPingResponse(_ pingEngine: SwiftPingEngine, response: PingResponse) -> Void
    func failedWithError(_ pingEngine: SwiftPingEngine, error: NSError) -> Void
    
}
