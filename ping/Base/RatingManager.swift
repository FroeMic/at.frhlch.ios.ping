//
//  RatingManager.swift
//  ping
//
//  Created by Michael Fröhlich on 23.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation
import Appirater

class RatingManager {
    
    static func setup() {
        Appirater.setAppId("1397401806")
        Appirater.setDaysUntilPrompt(5)
        Appirater.setUsesUntilPrompt(10)
        Appirater.setSignificantEventsUntilPrompt(10)
        Appirater.setTimeBeforeReminding(3)
        Appirater.setDebug(false)
        Appirater.appLaunched(true)
    }
    
    static func didEnterForeground() {
        Appirater.appEnteredForeground(true)
    }
    
    static func didSignificantEvent() {
        Appirater.userDidSignificantEvent(true)
    }
    
}
