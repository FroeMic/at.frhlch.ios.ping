//
//  SPPingController.swift
//  ping
//
//  Created by Michael Fröhlich on 29.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation
import GBPing

class SPPingController: NSObject, PingController {

    private var ip: String
    private let gpPing: GBPing
    
    var delegate: PingInfoDelegate?
    var host: String
    var configuration: PingConfiguration
    var isPinging: Bool = false
    
    private var pendingPingResults: [PingResult] = []
    private var completedPingResults: [PingResult] = []
    
    var pingResults: [PingResult] {
        return completedPingResults + pendingPingResults
    }
    
    private var sentPackages: [PingResult] {
        return pingResults
    }
    private var receivedPackages: [PingResult] {
        return completedPingResults.filter { $0.status == .success }
    }
    private var lostPackages: [PingResult] {
        return completedPingResults.filter { $0.status == .failure }
    }
    
    var statistic: PingStatistic {
        let packageLoss = completedPingResults.count == 0 ? 0 : Double(lostPackages.count) / Double(completedPingResults.count)
        
        let rtts = receivedPackages.map { $0.timeInMs }
        let minRtt: Double = rtts.min() ?? 0
        let maxRtt: Double = rtts.max() ?? 0
        let avgRTT: Double = rtts.count == 0 ? 0 : rtts.mean
        let stdevRtt: Double = rtts.stdev ?? 0
        
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
    
    private func updatePingResultStore(with pingResult: PingResult) {
        if pingResult.status == .pending {
            
            pendingPingResults.append(pingResult)
            
        } else {
            
            if let index = pendingPingResults.index(where: {$0.sequence == pingResult.sequence}) {
                
                pendingPingResults.remove(at: index)
                completedPingResults.append(pingResult)
            }
            
        }
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
    
    static func setupWithHost(host: String, configuration: PingConfiguration, success: @escaping (PingController) -> (), failure: @escaping (PingError) -> ()) {
        
        let ping = GBPing()
        let pingController = SPPingController(host: host, ip: host, configuration: configuration, ping: ping)
        
        ping.delegate = pingController
        ping.host = host
        ping.ttl = UInt(configuration.ttl)
        ping.timeout = configuration.timeout
        ping.payloadSize = UInt(configuration.payload)
        ping.pingPeriod = configuration.frequency
        
        ping.setup { (setupWasSuccessful, error) in
            
            if setupWasSuccessful {
                
                success(pingController)
                
            } else {
                
                failure(PingError.failedToResolveHost)
                
            }
            
        }
        
    }
    
}

extension SPPingController: GBPingDelegate {
    
    func ping(_ pinger: GBPing!, didFailWithError error: Error!) {
        let error = PingError.failedWithError
        
        delegate?.didFailWithError(self, error: error, result: nil)
    }
    
    func ping(_ pinger: GBPing!, didSendPingWith summary: GBPingSummary!) {
        
        if host != summary.host, summary.host != "" {
            ip = summary.host
        }
        
        let result = PingResult(status: .pending,
                                error: nil,
                                host: host,
                                ip: ip,
                                sizeInBytes: Int(summary.payloadSize),
                                sequence: Int(summary.sequenceNumber),
                                ttl: Int(summary.ttl),
                                timeInMs: 0)
        
        updatePingResultStore(with: result)
        delegate?.didSendPing(self, result: result)

    }
    
    func ping(_ pinger: GBPing!, didReceiveReplyWith summary: GBPingSummary!) {
        
        if host != summary.host, summary.host != "" {
            ip = summary.host
        }
        
        let result = PingResult(status: .success,
                                error: nil,
                                host: host,
                                ip: ip,
                                sizeInBytes: Int(summary.payloadSize),
                                sequence: Int(summary.sequenceNumber),
                                ttl: Int(summary.ttl),
                                timeInMs: summary.receiveDate.timeIntervalSince(summary.sendDate) * 1000)
        
        updatePingResultStore(with: result)
        delegate?.didReveivePingReply(self, result: result)
    }
    
    func ping(_ pinger: GBPing!, didTimeoutWith summary: GBPingSummary!) {
        
        if host != summary.host, summary.host != "" {
            ip = summary.host
        }
        
        let error = PingError.didTimedOut
        let result = PingResult(status: .failure,
                                error: error,
                                host: host,
                                ip: ip,
                                sizeInBytes: Int(summary.payloadSize),
                                sequence: Int(summary.sequenceNumber),
                                ttl: Int(summary.ttl),
                                timeInMs: self.configuration.timeout * 1000)

        updatePingResultStore(with: result)
        delegate?.didFailWithError(self, error: error, result: result)
    }
    

    func ping(_ pinger: GBPing!, didReceiveUnexpectedReplyWith summary: GBPingSummary!) {
        
        if host != summary.host, summary.host != "" {
            ip = summary.host
        }
        
        let error = PingError.receivedUnexpectedReply
        let result = PingResult(status: .failure,
                                error: error,
                                host: host,
                                ip: ip,
                                sizeInBytes: Int(summary.payloadSize),
                                sequence: Int(summary.sequenceNumber),
                                ttl: Int(summary.ttl),
                                timeInMs: 0)

        updatePingResultStore(with: result)
        delegate?.didFailWithError(self, error: error, result: result)
    }
    
    func ping(_ pinger: GBPing!, didFailToSendPingWith summary: GBPingSummary!, error: Error!) {
        
        if host != summary.host, summary.host != "" {
            ip = summary.host
        }
        
        let error = PingError.failedToSendPing
        let result = PingResult(status: .failure,
                                error: error,
                                host: host,
                                ip: ip,
                                sizeInBytes: Int(summary.payloadSize),
                                sequence: Int(summary.sequenceNumber),
                                ttl: Int(summary.ttl),
                                timeInMs: 0)

        updatePingResultStore(with: result)
        delegate?.didFailWithError(self, error: error, result: result)
    }
}
