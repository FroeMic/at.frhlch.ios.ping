//
//  TransactionStates.swift
//  ping
//
//  Created by Michael Fröhlich on 25.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

enum TransactionState {
    
    case purchased
    case restored
    case notRestored
    case failed
    
    var viewControllerShouldShowAlert: Bool {
        switch self {
        case .purchased:
            return false
        case .restored:
            return true
        case .notRestored:
            return true
        case .failed:
            return true
        }
    }
    
    var description: String {
        switch self {
        case .purchased:
            return "Purchase was successful!"
        case .restored:
            return "Restored all previous purchases."
        case .notRestored:
            return "Could not find any purchases to restore."
        case .failed:
            return "Ooops. Something went wrong."
        }
    }
    
}
