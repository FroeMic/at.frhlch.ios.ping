//
//  Host.swift
//  ping
//
//  Created by Michael Fröhlich on 12.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

struct Host {
    
    private static let nameKey: String = "name"
    private static let successKey: String = "success"
    private static let dateKey: String = "date"
    
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }
    
    let name: String
    let success: Bool
    let date: Date

    private var dateString: String {
        return Host.dateFormatter.string(from: date)
    }

    
    init(name: String, success: Bool, date: Date = Date() ) {
        self.name = name.lowercased()
        self.success = success
        self.date = date
    }
    
    init?(dict: Dictionary<String, String>) {
        
        guard dict.keys.contains(Host.nameKey),
            dict.keys.contains(Host.successKey),
            dict.keys.contains(Host.dateKey) else {
                return nil
        }
        guard let name = dict[Host.nameKey] else {
            return nil
        }
        guard let successText = dict[Host.successKey] else {
            return nil
        }
        guard let dateString = dict[Host.dateKey],
              let date = Host.dateFormatter.date(from: dateString) else {
            return nil
        }
        
        self.init(name: name, success: (successText == "1"), date: date)
    }
    
    func toDict() -> Dictionary<String, String> {
        return [
            Host.nameKey: name,
            Host.successKey: success ? "1" : "0",
            Host.dateKey: dateString
        ]
    }
    
}

