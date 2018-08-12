//
//  UDPingConfigurationRepository.swift
//  ping
//
//  Created by Michael Fröhlich on 05.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

class UDPingConfigurationRepository {
    
    fileprivate let savedConfiguration = "pingConfiguration"
    fileprivate let defaults = UserDefaults.standard
    
    func reset() {
        store(pingConfiguration: PingConfiguration())
    }
    
}

extension UDPingConfigurationRepository: PingConfigurationProvider {
    
    func get() -> PingConfiguration {
        guard let configurationDict = defaults.dictionary(forKey: savedConfiguration) as? Dictionary<String, String> else {
            reset()
            return get()
        }
        
        guard let configuration = PingConfiguration(dict: configurationDict) else {
            return PingConfiguration()
        }
        
        return configuration
    }
    
    func store(pingConfiguration: PingConfiguration) {
        defaults.set(pingConfiguration.toDict(), forKey: savedConfiguration)
    }
    
    
}

