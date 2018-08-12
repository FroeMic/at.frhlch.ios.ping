//
//  UDTipRepository.swift
//  tip
//
//  Created by Michael Fröhlich on 10.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

class UDTHostHistoryRepository {

    fileprivate let savedHostHistoryKey = "hostHistoryRepository"
    fileprivate let defaults = UserDefaults.standard
    fileprivate var subscribers: [HostHistoryObserver] = []
    
    fileprivate func store(hosts: [Host]) {
        let dictHosts = hosts.map( { $0.toDict() })
        defaults.set(dictHosts, forKey: savedHostHistoryKey)
    }
    
}

extension UDTHostHistoryRepository: HostHistoryRepository {
    func get() -> [Host] {
        guard let history = defaults.array(forKey: savedHostHistoryKey) else {
            reset()
            return get()
        }

        var hosts: [Host] = []
        for element in history {
            if let dict = element as? Dictionary<String, String>,
               let host = Host(dict: dict) {
                hosts.append(host)
            }
        }

        hosts.sort(by: { $0.date > $1.date })
        
        return hosts
    }
    
    func store(host: Host) {
        var hosts = get()

        if let _ = hosts.index(where: { $0.name == host.name }) {
            update(host: host)
            return
        }

        hosts.append(host)
        store(hosts: hosts)
        
        notify(host)
    }
    
    func remove(host: Host) {
        let hosts = get()

        var newHosts: [Host] = []
        for currentHost in hosts {
            if host.name != currentHost.name {
                newHosts.append(currentHost)
            } 
        }

        store(hosts: newHosts)
    }
    
    func update(host: Host) {
        let hosts = get()

        var newHosts: [Host] = []
        for currentHost in hosts {
            if host.name == currentHost.name {
                newHosts.append(host)
            } else {
                newHosts.append(currentHost)
            }
        }

        store(hosts: newHosts)
    }
    
    func reset() {
        store(hosts: [])
    }
    
}

extension UDTHostHistoryRepository: HostHistoryPublisher {
    
    func subscribe(_ subscriber: HostHistoryObserver) {
        if let _ = subscribers.index(where: {$0 === subscriber}) {
            // do nothing, already subscribed
        } else {
            subscribers.append(subscriber)
        }
    }
    
    func unsubscribe(_ subscriber: HostHistoryObserver) {
        if let index = subscribers.index(where: {$0 === subscriber}) {
            subscribers.remove(at: index)
        } else {
            // do nothing
        }
    }
    
    func notify(_ host: Host) {
        let allHosts = get()
        for subscriber in subscribers {
            subscriber.update(allHosts, new: host)
        }
    }
    
}
