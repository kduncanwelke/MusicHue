//
//  StoreObserver.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 9/11/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import StoreKit
import AnimatedGradientView

class StoreObserver: NSObject, SKPaymentTransactionObserver {
	
	static let iapObserver = StoreObserver()
	var restored: [String] = []
	var purchased: [String] = []
	static var isComplete = false
	
	override init() {
		super.init()
	}
	
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		print("updating transactions")
		for transaction in transactions {
			switch transaction.transactionState {
			case .purchasing:
				break
			// Do not block your UI. Allow the user to continue using your app.
			case .deferred:
				print("deferred")
			// The purchase was successful.
			case .purchased:
				if !transaction.downloads.isEmpty {
					queue.start(transaction.downloads)
				}
				print("purchase succeeded")
			// The transaction failed.
			case .failed:
				queue.finishTransaction(transaction)
				print("failed")
			// There are restored products.
			case .restored:
				if !transaction.downloads.isEmpty {
					queue.start(transaction.downloads)
				}
				print("restored")
			default:
				break
			}
		}
	}
	
	func paymentQueue(_ queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
		for download in downloads {
			
			if download == downloads.last {
				StoreObserver.isComplete = true
			}
			
			switch download.state {
			case .active:
				print("active")
			case .cancelled:
				print("cancelled")
			case .failed:
				print("failed")
			case .paused:
				print("paused")
			case .waiting:
				print("waiting")
			case .finished:
				print("finished")
				processDownload(download: download)
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
	
	func processDownload(download: SKDownload) {
		guard let hostedContentPath = download.contentURL?.appendingPathComponent("Contents") else {
			print("Download failed")
			return
		}
		
		do {
			// get downloaded file
			var files = try FileManager.default.contentsOfDirectory(atPath: hostedContentPath.relativePath)
			
			for file in files {
				var source = hostedContentPath.appendingPathComponent(file)
				
				URLSession.shared.dataTask(with: source) { (data, response, error) in
					if error != nil {
						print("Error loading URL.")
					}
				}
				do {
					// extract data
					var data = try Data(contentsOf: source)
					var gradient = try? PropertyListDecoder().decode(Gradient.self, from: data)
					
					if let loaded = gradient {
						GradientManager.gradientToSave = loaded
						NotificationCenter.default.post(name: NSNotification.Name(rawValue: "saveGradient"), object: nil)
						print(GradientManager.purchasedGradients)
						
					} else {
						print("Could not convert plist to gradient")
					}
				} catch {
					print("Error loading gradient data.")
				}
			}
		} catch let error {
			print("Error: \(error)")
		}
		
		if StoreObserver.isComplete {
			// finish transactions after downloads have been processed
			for transaction in SKPaymentQueue.default().transactions {
				guard transaction.transactionState != .purchasing, transaction.transactionState != .deferred else {
					return
				}
				
				//Transaction can now be safely finished
				SKPaymentQueue.default().finishTransaction(transaction)
			}
			
			// tell table to reload
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
			StoreObserver.isComplete = false
		}
	}
}
