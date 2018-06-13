//
//  Array+stdev.swift
//  ping
//
//  Created by Michael Fröhlich on 13.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

extension Array where Element: FloatingPoint {
    
    /// The mean average of the items in the collection.
    
    var mean: Element { return reduce(Element(0), +) / Element(count) }
    
    /// The unbiased sample standard deviation. Is `nil` if there are insufficient number of items in the collection.
    
    var stdev: Element? {
        guard count > 1 else { return nil }
        
        return sqrt(sumSquaredDeviations() / Element(count - 1))
    }
    
    /// The population standard deviation. Is `nil` if there are insufficient number of items in the collection.
    
    var stdevp: Element? {
        guard count > 0 else { return nil }
        
        return sqrt(sumSquaredDeviations() / Element(count))
    }
    
    /// Calculate the sum of the squares of the differences of the values from the mean
    ///
    /// A calculation common for both sample and population standard deviations.
    ///
    /// - calculate mean
    /// - calculate deviation of each value from that mean
    /// - square that
    /// - sum all of those squares
    
    private func sumSquaredDeviations() -> Element {
        let average = mean
        return map {
            let difference = $0 - average
            return difference * difference
            }.reduce(Element(0), +)
    }
}
