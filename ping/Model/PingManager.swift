//
//  PingManager.swift
//  ping
//
//  Created by Michael Fröhlich on 13.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

protocol PingManager {
    
    var delegate: PingDelegate? {get set}
    
    var sentPackages: Int { get }
    var receivedPackages: Int { get }
    var lostPackages: Int { get }
    var packagesLoss: Double { get }
    var minRTT: Double { get }
    var maxRTT: Double { get }
    var avgRTT: Double { get }
    var stdevRTT: Double { get }
    
    func startPing(hostName: String, addressStyle: IPAddressStyle?)
    func stopPing()
    
}
