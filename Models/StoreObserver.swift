//
//  StoreObserver.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 9/11/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import StoreKit

class StoreObserver: NSObject, SKPaymentTransactionObserver {
	
	static let iapObserver = StoreObserver()
	var restored: [String] = []
	var purchased: [String] = []
	
	override init() {
		super.init()
	}
	
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		for transaction in transactions {
			switch transaction.transactionState {
			case .purchasing:
				break
			// Do not block your UI. Allow the user to continue using your app.
			case .deferred:
				print("deferred")
			// The purchase was successful.
			case .purchased:
				retrievePurchase(id: transaction.payment.productIdentifier)
				NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
				queue.finishTransaction(transaction)
				print("purchase succeeded")
			// The transaction failed.
			case .failed:
				queue.finishTransaction(transaction)
				print("failed")
			// There are restored products.
			case .restored:
				retrievePurchase(id: transaction.payment.productIdentifier)
				NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
				queue.finishTransaction(transaction)
				print("restored")
			default:
				break
			}
		}
	}
	
	func buy(_ product: SKProduct) {
		let payment = SKMutablePayment(product: product)
		SKPaymentQueue.default().add(payment)
	}
	
	func restore() {
		SKPaymentQueue.default().restoreCompletedTransactions()
	}
	
	func retrievePurchase(id: String) {
		for index in 0...(GradientManager.premiumList.count - 1) {
			let name = id.dropFirst(9)
			
			if GradientManager.premiumList[index].name.rawValue == name {
				GradientManager.premiumList[index].purchased = true
			}
		}
	}
}
