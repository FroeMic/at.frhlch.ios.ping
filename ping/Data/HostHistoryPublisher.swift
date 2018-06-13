//
//  Observer.swift
//  ping
//
//  Created by Michael Fröhlich on 12.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

protocol HostHistoryObserver: class {
    func update(_ all: [Host], new: Host)
}

protocol HostHistoryPublisher: class {
    func subscribe(_ subscriber: HostHistoryObserver)
    func unsubscribe(_ subscriber: HostHistoryObserver)
    func notify(_ host: Host)
}
