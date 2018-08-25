//
//  StoreKitManager.swift
//  ping
//
//  Created by Michael Fröhlich on 25.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import Kvitto

class StoreKitManager {
    
    static let shared = StoreKitManager()
    
    var receiptData: Data? {
        return SwiftyStoreKit.localReceiptData
    }
    var receiptString: String? {
        return receiptData?.base64EncodedString(options: [])
    }
    
    var purchaseFinishedBlock: ((TransactionState)->())?
    
    private init() { }
    
    func registerTransactionObserver() {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    
                    self.purchaseFinishedBlock?(.purchased)
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        
    }
    
    /**
     * Fetches the receipt from Apple' Servers and verifies it locally.
     */
    func fetchReceipt(completed: @escaping (Bool)->() = { _ in } ) {
        
        guard let _ = self.receiptData else {
            completed(false)
            return
        }
        
        
        SwiftyStoreKit.fetchReceipt(forceRefresh: false) { result in
            switch result {
            case .success(let _):
                completed(true)
            case .error(let _):
                completed(false)
            }
        }
    }
    
    func purchaseProduct(id: String) {
        SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let product):
                let downloads = product.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                self.purchaseFinishedBlock?(.purchased)
            case .error(let error):
                print("\(error)")
            }
        }
    }
    
    func restorePurchases() {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                self.purchaseFinishedBlock?(.failed)
            }
            else if results.restoredPurchases.count > 0 {
                self.purchaseFinishedBlock?(.restored)
            }
            else {
                self.purchaseFinishedBlock?(.notRestored)
            }
        }
    }
    
    
    func verifyReceipt(receipt: Receipt) -> Bool {
        
        guard let opaqueValue = receipt.opaqueValue else {
            return false
        }
        guard let bundleIdentifierData = receipt.bundleIdentifierData else {
            return false
        }
        guard let receiptHash = receipt.SHA1Hash else {
            return false
        }
        
        let bundle = Bundle.main
        let bundleIdentifier = bundle.bundleIdentifier
        let appVersion = bundle.infoDictionary![String(kCFBundleVersionKey)] as? String ?? ""
        let vendorIdentifier = UIDevice.current.identifierForVendor
        
        if receipt.bundleIdentifier != bundleIdentifier {
            return false
        }
        
        if receipt.appVersion != appVersion {
            return false
        }
        
        guard var uuid = vendorIdentifier?.uuid else {
            return false
        }
        
        let vendorData = NSData(bytes: &uuid, length: 16) as Data
        
        let hashData = NSMutableData()
        hashData.append(vendorData)
        hashData.append(opaqueValue)
        hashData.append(bundleIdentifierData)
        
        guard let hash = hashData.withSHA1Hash() else {
            return false
        }
        
        if hash != receiptHash {
            return false
        }
        
        return true
    }
    
    func doesOwnProduct(id: String) -> Bool {
        
        guard let receiptUrl = Bundle.main.appStoreReceiptURL else {
            return false
        }
        guard let receipt = Receipt(contentsOfURL: receiptUrl) else {
            return false
        }

        if !verifyReceipt(receipt: receipt) {
            return false
        }
        
        for inAppReceipt in receipt.inAppPurchaseReceipts ?? [] {
            if inAppReceipt.productIdentifier == id {
                return true
            }
        }
        return false
    }
    
}

