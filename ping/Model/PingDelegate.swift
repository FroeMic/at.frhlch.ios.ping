//
//  PingDelegate.swift
//  ping
//
//  Created by Michael Fröhlich on 12.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

protocol PingDelegate {
    
    func didStartWithAddress(host: Host)
    func didFailWithAddress(host: Host, error: String)
    func didReceivePingResponse(_ pingResponse: PingResult)
    
}
