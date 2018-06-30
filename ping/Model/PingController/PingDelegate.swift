//
//  PingDelegate.swift
//  ping
//
//  Created by Michael Fröhlich on 28.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

protocol PingDelegate {
    
    func didFailWithError(_ pingController: PingController, error: PingError, result: PingResult?)
    func didSendPing(_ pingController: PingController, result: PingResult)
    func didReveivePingReply(_ pingController: PingController, result: PingResult)
    
}
