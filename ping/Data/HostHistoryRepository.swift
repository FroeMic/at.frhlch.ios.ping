//
//  TipPrototypeRepository.swift
//  tip
//
//  Created by Michael Fröhlich on 10.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

// TODO: Implement this whole thing with generics
protocol HostHistoryRepository: HostHistoryPublisher {
    
    func get() -> [Host]
    
    func store(host: Host)
    
    func remove(host: Host)
    
    func update(host: Host)
    
    func reset()
}
