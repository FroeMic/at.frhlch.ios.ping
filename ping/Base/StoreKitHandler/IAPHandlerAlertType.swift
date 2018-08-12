//
//  IAPHandlerAlertType.swift
//  ping
//
//  Created by Michael Fröhlich on 12.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit
import StoreKit

enum IAPHandlerAlertType{
    case disabled
    case restored
    case purchased
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}
