//
//  QNNPingManager.swift
//  ping
//
//  Created by Michael Fröhlich on 13.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation
import QNNetDiag

class FailedToResolveHostError: Error {
    var localizedDescription: String = "Failed to resolve host"
}
class InvalidResponseCodeError: Error {
    var localizedDescription: String = "Invalid response code"
}
class RequestTimedOutError: Error {
    
    let seq: Int
    
    init(seq: Int) {
        self.seq = seq
    }
    
    var localizedDescription: String {
        return "Request timed out for seq=\(seq)"
    }
}

class QNNPingManager: NSObject {
    
    static private let successResponseCode = 0
    static private let requestDidStopCode = -2
    static private let couldNotResolveHostErrorCode = -1006
    static private let timeOutCode = 65
    static private let invalidPingResponseCode = -22001
    
    var delegate: PingDelegate?
    private var pinger: QNNPing?
    private var sendTimer: Timer?
    private var lastSendTime: TimeInterval = 0.0
    private var running: Bool = false
    private var currentHost: String = ""
    private var endpoint: String?
    
    private var count: Int = 0
    private var pingResults: [PingResult] = []
    
    private var allRtts: [Double] {
        return pingResults.map { $0.timeInMs }
    }
    private var successfullRTTs: [Double] {
        return pingResults.filter { $0.error == nil }.map{ $0.timeInMs }
    }
    
    @objc func handleUpdatedPing(_ pingResponse: QNNPingResponse, _ pingResult: QNNPingResult) {
        var error: String? = nil
        
        switch pingResponse.code {
        case QNNPingManager.successResponseCode:
            if pingResults.count == 0 {
                let host = Host(name: currentHost, success: true)
                delegate?.didStartWithAddress(host: host)
                endpoint = pingResponse.ip
            }
        case QNNPingManager.timeOutCode:
            error = RequestTimedOutError(seq: self.count).localizedDescription
        case QNNPingManager.couldNotResolveHostErrorCode:
            error = FailedToResolveHostError().localizedDescription
        case QNNPingManager.invalidPingResponseCode:
            error = InvalidResponseCodeError().localizedDescription
        case QNNPingManager.requestDidStopCode:
            return
        default:
            ()
        }

        let pingResult = PingResult(host: pingResponse.ip,
                                    sizeInBytes: Int(pingResponse.size),
                                    sequence: self.count,
                                    ttl: pingResponse.ttl,
                                    timeInMs: pingResponse.rtt,
                                    error: error)
        
        if running {
            pingResults.append(pingResult)
        }
        
        self.delegate?.didReceivePingResponse(pingResult)
    }
    
    @objc func handleCompletedPing(_ pingResult: QNNPingResult) {
        if pingResult.code == QNNPingManager.successResponseCode {
            return
        }
        
        if pingResult.code == QNNPingManager.couldNotResolveHostErrorCode {
            let host = Host(name: currentHost, success: false)
            delegate?.didFailWithAddress(host: host, error: FailedToResolveHostError().localizedDescription)
            stopPing()
        }
    
    }
    
    @objc func sendPing() {
        if running {
            self.count += 1
        }
        
        let endpoint = self.endpoint ?? currentHost
        QNNPing.start(endpoint, size: 56, output: self, update: { (qnnPingResponse, qnnPingResult) in
            
            if let pingResponse = qnnPingResponse, let pingResult = qnnPingResult {
                self.handleUpdatedPing(pingResponse, pingResult)
            }
            
        }, complete: { (qnnPingResult) in
            
            if let pingResult = qnnPingResult {
                self.handleCompletedPing(pingResult)
            }
            
        }, interval: 1, count: 1)
    }
    
}

extension QNNPingManager: PingManager {
    
    var sentPackages: Int {
        return count
    }
    var receivedPackages: Int {
        return pingResults.filter({ $0.error == nil }).count
    }
    var lostPackages: Int {
        return sentPackages - receivedPackages
    }
    var packagesLoss: Double {
        return Double(lostPackages) / Double(sentPackages)
    }
    var minRTT: Double {
        return successfullRTTs.min() ?? 0.0
    }
    var maxRTT: Double {
        return successfullRTTs.max() ?? 0.0
    }
    var avgRTT: Double {
        return successfullRTTs.mean
    }
    var stdevRTT: Double {
        return successfullRTTs.stdev ?? 0.0
    }
    
    func startPing(hostName: String, addressStyle: IPAddressStyle?) {
        
        if running {
            stopPing()
            startPing(hostName: hostName, addressStyle: addressStyle)
            return
        }
        
        running = true
        currentHost = hostName
        pingResults = []
        count = 0
        if sendTimer == nil  {
            self.sendTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(QNNPingManager.sendPing), userInfo: nil, repeats: true)
        }
    }
    
    func stopPing() {
        running = false
        sendTimer?.invalidate()
        sendTimer = nil
        endpoint = nil
    
        let pingResult = PingResult(host: "Ping Terminated",
                                    sizeInBytes: 0,
                                    sequence: 0,
                                    ttl: 0,
                                    timeInMs: 0,
                                    error: "")
        
        
        self.delegate?.didReceivePingResponse(pingResult)
    }
    
}

extension QNNPingManager: QNNOutputDelegate {
    func write(_ line: String!) {
        // print(line)
    }
}

