//
//  PingStatistics.swift
//  ping
//
//  Created by Michael Fröhlich on 29.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

struct PingStatistic {

    let sentPackages: Int
    let receivedPackages: Int
    let lostPackages: Int
    let packagesLoss: Double
    let minRTT: Double
    let maxRTT: Double
    let avgRTT: Double
    let stdevRTT: Double
}
