//
//  PingController.swift
//  ping
//
//  Created by Michael Fröhlich on 28.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

protocol PingController {
    
    var delegate: PingInfoDelegate? { get set }
    var configuration: PingConfiguration { get }
    var statistic: PingStatistic { get }
    var pingResults: [PingResult] { get }
    var isPinging: Bool { get }
    
    /**
     * Use this function to setup the Ping Controller.
     * If a host could be resolved the initialized PingController is returned.
     * If the host could not be resolved or another issue occured, the failure callback is triggered.
     */
    static func setupWithHost(host: String, configuration: PingConfiguration, success: (PingController) -> (), failure: (PingError) -> ())
    
    /**
     * Starts pinging.
     */
    func start() 
    
    /**
     * Stops pinging.
     */
    func stop()
    
}


extension PingController {
    
    /**
     * Use this function to setup the Ping Controller.
     * If a host could be resolved the initialized PingController is returned.
     * If the host could not be resolved or another issue occured, the failure callback is triggered.
     */
    static func setupWithHost(host: String, success: (PingController) -> (), failure: (PingError) -> ()) {
        setupWithHost(host: host, configuration: PingConfiguration(), success: success, failure: failure)
    }
    
}
