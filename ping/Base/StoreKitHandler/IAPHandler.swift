//
//  IAPHandler.swift
//  ping
//
//  Created by Michael Fröhlich on 12.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit
import StoreKit

class IAPHandler: NSObject {
    static let shared = IAPHandler()
    
    let PING_PREMIUM_PRODUCT_ID = "at.frhlch.ios.ping.pingpremium"
    
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]() {
        didSet {
            // TODO: check for all products whether they were bought already
            // at the moment one user can login with his / her AppStore Id, restore a purchase
            // and logout again, and the purchase will stay on the device
        }
    }
    
    var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(index: Int){
        if iapProducts.count == 0 { return }
        
        if self.canMakePurchases() {
            let product = iapProducts[index]
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            productID = product.productIdentifier
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(){
        
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects:
            PING_PREMIUM_PRODUCT_ID
        )
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        
        if (response.products.count > 0) {
            iapProducts = response.products
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseStatusBlock?(.restored)
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                didBuyProduct(id: transaction.payment.productIdentifier)
                purchaseStatusBlock?(.purchased)
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                purchaseStatusBlock?(.failed)
                break
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                didBuyProduct(id: transaction.payment.productIdentifier)
                purchaseStatusBlock?(.failed)
                break
            default:
                break
            }
        }
    }
}

extension IAPHandler {
    
    func doesOwnProduct(id: String) -> Bool {
        let boughtProductKey = "IABoughtProducts"
        let defaults = UserDefaults.standard
        let boughtProducts = defaults.dictionary(forKey: boughtProductKey) as? Dictionary<String, Bool> ?? [:]
        return boughtProducts[id] ?? false
    }
    
    func didBuyProduct(id: String) {
        let boughtProductKey = "IABoughtProducts"
        let defaults = UserDefaults.standard
        
        var boughtProducts = defaults.dictionary(forKey: boughtProductKey) as? Dictionary<String, Bool> ?? [:]
        boughtProducts[id] = true
        
        defaults.set(boughtProducts, forKey: boughtProductKey)

        
    }
    
}
