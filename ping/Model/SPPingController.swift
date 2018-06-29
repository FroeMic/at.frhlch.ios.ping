//
//  SPPingController.swift
//  ping
//
//  Created by Michael Fröhlich on 29.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation
import GBPing

class SPPingController: PingController {

    private var ip: String
    private let gpPing: GBPing
    
    var delegate: PingInfoDelegate?
    var host: String
    var configuration: PingConfiguration
    var isPinging: Bool = false
    
    private (set) var pingResults: [PingResult] = []
    
    private var sentPackages: [PingResult] {
        return pingResults.filter { $0.status == .success }
    }
    private var receivedPackages: [PingResult] {
        return pingResults.filter { $0.status == .failure }
    }
    private var lostPackages: [PingResult] {
        return pingResults.filter { $0.status == .failure }
    }
    
    var statistic: PingStatistic {
        let packageLoss = sentPackages.count == 0 ? 0 : Double(lostPackages.count) / Double(sentPackages.count)
        let minRtt: Double = 0 //receivedPackages.min() ?? 0
        let maxRtt: Double = 0 //receivedPackages.max() ?? 0
        let avgRTT: Double = 0 //receivedPackages.mean ?? 0
        let stdevRtt: Double = 0 //receivedPackages.stdev ?? 0
        
        return PingStatistic(sentPackages: sentPackages.count,
                             receivedPackages: receivedPackages.count,
                             lostPackages: lostPackages.count,
                             packagesLoss: packageLoss,
                             minRTT: minRtt,
                             maxRTT: maxRtt,
                             avgRTT: avgRTT,
                             stdevRTT: stdevRtt)
    }
    
    
    private init(host: String, ip: String, configuration: PingConfiguration, ping: GBPing) {
        self.host = host
        self.ip = ip
        self.configuration = configuration
        self.gpPing = ping
    }
    
    

    
}

// MARK: PingController
extension SPPingController {
    
    func start() {
        
        if isPinging {
            stop()
        }
        
        gpPing.startPinging()
        isPinging = true
        
    }
    
    func stop() {
        gpPing.stop()
        isPinging = false
    }
    
    static func setupWithHost(host: String, configuration: PingConfiguration, success: (PingController) -> (), failure: (PingError) -> ()) {
        
        
        // TODO:    [1] Try to resolve host to ip
        //          [2] Init Ping Controller or call failure callback
        
    }
    
}
