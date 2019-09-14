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
					retrievePurchase(id: transaction.payment.productIdentifier)
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
					retrievePurchase(id: transaction.payment.productIdentifier)
				}
				print("restored")
			default:
				break
			}
		}
	}
	
	func paymentQueue(_ queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
		for download in downloads {
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
	
	func retrievePurchase(id: String) {
		for index in 0...(GradientManager.premiumList.count - 1) {
			let name = id.dropFirst(9)
			
			if GradientManager.premiumList[index].name.rawValue == name {
				GradientManager.premiumList[index].purchased = true
			}
		}
		
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
	}
	
	func processDownload(download: SKDownload) {
		guard let hostedContentPath = download.contentURL?.appendingPathComponent("Contents") else {
			print("failed")
			return
		}
		
		do {
			let files = try FileManager.default.contentsOfDirectory(atPath: hostedContentPath.relativePath)
			
			for file in files {
				let source = hostedContentPath.appendingPathComponent(file)
				
				URLSession.shared.dataTask(with: source) { (data, response, error) in
					if error != nil {
						print("Error loading URL.")
					}
				}
				do {
					let data = try Data(contentsOf: source)
					let gradient = try? PropertyListDecoder().decode(Gradient.self, from: data)
					
					if let loaded = gradient, let first = GradientManager.convertToDirection(direction: loaded.firstDirection), let second = GradientManager.convertToDirection(direction: loaded.secondDirection), let third = GradientManager.convertToDirection(direction: loaded.thirdDirection), let fourth = GradientManager.convertToDirection(direction: loaded.fourthDirection) {
						
						let premiumGradient: [AnimatedGradientView.AnimationValue] = [(colors: loaded.first, first, .axial), (colors: loaded.second, second, .axial), (colors: loaded.third, third, .axial),(colors: loaded.fourth, fourth, .axial)]
						
						let color: ColorName = {
							if loaded.name == "Unicorn" {
								return ColorName.unicorn
							} else {
								return .automatic
							}
						}()
						print("retrieving")
						print(color)
						print(premiumGradient)
						
						GradientManager.purchasedGradients.updateValue(premiumGradient, forKey: color)
						print(GradientManager.purchasedGradients)
						
					} else {
						print("could not convert")
					}
				} catch {
					print("Error loading gradient data.")
				}
			}
		} catch {
			print("error")
		}
		
		for transaction in SKPaymentQueue.default().transactions {
			guard transaction.transactionState != .purchasing, transaction.transactionState != .deferred else {
				return
			}
			
			//Transaction can now be safely finished
			SKPaymentQueue.default().finishTransaction(transaction)
		}
	}
}
