//
//  ColorTableViewController.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 8/24/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import AnimatedGradientView
import StoreKit

class ColorTableViewController: UITableViewController {
	
	// MARK: Variables
	
	var request: SKProductsRequest!
	var products = [SKProduct]()
	var hasLoaded = false
	var purchaseCell: ColorTableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: "reload"), object: nil)
		
		var isAuthorizedForPayments: Bool {
			return SKPaymentQueue.canMakePayments()
		}
		
		if isAuthorizedForPayments {
			validate(productIdentifiers: [Products.unicorn])
		}
    }
	
	// MARK: Custom functions
	
	@objc func reload() {
		guard let cell = purchaseCell else { return }
		cell.purchaseButton.setTitle("Purchased", for: .normal)
	}
	
	func validate(productIdentifiers: [String]) {
		let productIdentifiers = Set(productIdentifiers)
		
		request = SKProductsRequest(productIdentifiers: productIdentifiers)
		request.delegate = self
		request.start()
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
        	return GradientManager.colorList.count
		} else {
			return GradientManager.premiumList.count
		}
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath) as! ColorTableViewCell

		cell.cellDelegate = self
		
		if indexPath.section == 0 {
			var color: Color
			
			color = GradientManager.colorList[indexPath.row]
			
			// Configure the cell...
			cell.colorName.text = color.name.rawValue
			cell.descriptionLabel.text = color.description
			
			let animatedGradient = AnimatedGradientView(frame: cell.colorPreview.bounds)
			animatedGradient.animationValues = color.color
			cell.colorPreview.addSubview(animatedGradient)
			
			if color.name == GradientManager.currentGradient.name {
				tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
			}
			
			cell.purchaseButton.isHidden = true
			
			return cell
			
		} else {
			var product: SKProduct
			
			var color: Color
			
			color = GradientManager.premiumList[indexPath.row]
			
			// Configure the cell...
			cell.colorName.text = color.name.rawValue
			cell.descriptionLabel.text = color.description
			
			let animatedGradient = AnimatedGradientView(frame: cell.colorPreview.bounds)
			animatedGradient.animationValues = color.color
			cell.colorPreview.addSubview(animatedGradient)
			
			cell.purchaseButton.isHidden = false
			
			if !products.isEmpty {
				product = products[indexPath.row]
				
				// prevent selection if not purchased
				if color.purchased {
					cell.purchaseButton.setTitle("Purchased", for: .normal)
				} else {
					cell.purchaseButton.setTitle(product.regularPrice, for: .normal)
				}
			} else {
				if color.purchased {
					cell.purchaseButton.setTitle("Purchased", for: .normal)
				} else {
					cell.purchaseButton.setTitle("Unavailable", for: .normal)
				}
			}
			
			if color.name == GradientManager.currentGradient.name {
				tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
			}
			
			return cell
		}
    }
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			GradientManager.currentGradient = GradientManager.colorList[indexPath.row]
		} else {
			if GradientManager.premiumList[indexPath.row].purchased {
				GradientManager.currentGradient = GradientManager.premiumList[indexPath.row]
			}
		}
	}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	
	// MARK: IBActions
	
	@IBAction func restorePressed(_ sender: UIBarButtonItem) {
		if NetworkMonitor.connection {
			StoreObserver.iapObserver.restore()
		} else {
			showAlert(title: "Purchases unavailable", message: "Purchases cannot be restored without a working network connection")
		}
	}
	
	
	@IBAction func donePressed(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}
}


extension ColorTableViewController: SKProductsRequestDelegate {
	
	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		if !response.products.isEmpty {
			products = response.products
			for product in products {
				print(product.localizedTitle)
				print(product.price)
				print(product.priceLocale)
			}
		}
		
		for invalidIdentifier in response.invalidProductIdentifiers {
			// handle invalid case
		}
	}
}


extension ColorTableViewController: CellButtonTapDelegate {
	func didTapButton(sender: ColorTableViewCell) {
		print("delegate called")
		let path = self.tableView.indexPath(for: sender)
		
		if let selected = path {
			if GradientManager.premiumList[selected.row].purchased {
				return
			} else {
				if NetworkMonitor.connection {
					
					var isAuthorizedForPayments = SKPaymentQueue.canMakePayments()
					
					if isAuthorizedForPayments {
						StoreObserver.iapObserver.buy(products[selected.row])
						purchaseCell = tableView.cellForRow(at: selected) as! ColorTableViewCell
					} else {
						showAlert(title: "Payments not authorized", message: "This device is not permitted to process payments")
					}
				} else {
					showAlert(title: "Purchases unavailable", message: "Purchases cannot be processed without a network connection - please try again")
				}
			}
		}
	}
}
