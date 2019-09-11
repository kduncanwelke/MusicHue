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
	var restored = [SKPaymentTransaction]()
	var purchased = [SKPaymentTransaction]()
	
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
				GradientManager.gradientPurchase.purchased = true
				purchased.append(transaction)
				queue.finishTransaction(transaction)
				print("purchase succeeded")
			// The transaction failed.
			case .failed:
				queue.finishTransaction(transaction)
				print("failed")
			// There are restored products.
			case .restored:
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
		if !restored.isEmpty {
			restored.removeAll()
		}
		
		SKPaymentQueue.default().restoreCompletedTransactions()
	}
}
