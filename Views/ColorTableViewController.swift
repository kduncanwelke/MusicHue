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
import CoreData

class ColorTableViewController: UITableViewController {
	
	// MARK: Variables
	
	var request: SKProductsRequest!
	var products = [SKProduct]()
	var hasLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: "reload"), object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(saveGradient), name: NSNotification.Name(rawValue: "saveGradient"), object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(networkRestored), name: NSNotification.Name(rawValue: "networkRestored"), object: nil)
		
		getProducts()
    }
	
	// MARK: Custom functions
	
	@objc func reload() {
		tableView.reloadData()
		print("reloaded")
	}
	
	@objc func networkRestored() {
		if products.isEmpty {
			getProducts()
		}
	}
	
	func getProducts() {
		var isAuthorizedForPayments: Bool {
			return SKPaymentQueue.canMakePayments()
		}
		
		if isAuthorizedForPayments {
			validate(productIdentifiers: [Products.unicorn])
		}
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
        	return GradientManager.colorPreviews.count
		} else {
			return GradientManager.premiumList.count
		}
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath) as! ColorTableViewCell

		cell.cellDelegate = self
		
		if indexPath.section == 0 {
			var color: Color
			
			color = GradientManager.colorPreviews[indexPath.row]
			
			// Configure the cell...
			cell.colorName.text = color.name.rawValue
			cell.descriptionLabel.text = color.description
			
			let animatedGradient = AnimatedGradientView(frame: cell.colorPreview.bounds)
			animatedGradient.animationValues = color.color
			cell.colorPreview.addSubview(animatedGradient)
			
			if color.name == GradientManager.currentGradientName {
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
				if GradientManager.purchasedGradients[color.name] != nil {
					cell.purchaseButton.setTitle("Purchased", for: .normal)
				} else {
					cell.purchaseButton.setTitle(product.regularPrice, for: .normal)
				}
			} else {
				if GradientManager.purchasedGradients[color.name] != nil {
					cell.purchaseButton.setTitle("Purchased", for: .normal)
				} else {
					cell.purchaseButton.setTitle("Unavailable", for: .normal)
				}
			}
			
			if color.name == GradientManager.currentGradientName {
				tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
			}
			
			return cell
		}
    }
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			let selectedName = GradientManager.colorPreviews[indexPath.row].name
			GradientManager.currentGradientName = selectedName
			GradientManager.currentGradient = GradientManager.colorList[selectedName]
			print(selectedName)
		} else {
			if GradientManager.purchasedGradients[GradientManager.premiumList[indexPath.row].name] != nil  {
				let selectedName = GradientManager.premiumList[indexPath.row].name
				GradientManager.currentGradientName = selectedName
				GradientManager.currentGradient = GradientManager.purchasedGradients[selectedName]
				print(selectedName)
			} else {
				tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
				return
			}
		}
	}
	
	// MARK: Custom functions
	
	@objc func saveGradient() {
		if let loaded = GradientManager.gradientToSave {
			
			// prevent resave of existing purchase
			if let name = ColorName.init(rawValue: loaded.name) {
				if GradientManager.purchasedGradients[name] != nil {
					return
				}
			}
			var managedContext = CoreDataManager.shared.managedObjectContext
			
			let newPremiumGradient = SavedGradient(context: managedContext)
			
			newPremiumGradient.name = loaded.name
			newPremiumGradient.firstDirection = loaded.firstDirection
			newPremiumGradient.firstColorSet = loaded.first
			
			newPremiumGradient.secondDirection = loaded.secondDirection
			newPremiumGradient.secondColorSet = loaded.second
			
			newPremiumGradient.thirdDirection = loaded.thirdDirection
			newPremiumGradient.thirdColorSet = loaded.third
			
			newPremiumGradient.fourthDirection = loaded.fourthDirection
			newPremiumGradient.fourthColorSet = loaded.fourth
			
			do {
				try managedContext.save()
				print("saved gradient")
				GradientManager.addToPurchased(loaded: loaded)
			} catch {
				// this should never be displayed but is here to cover the possibility
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
			
			tableView.reloadData()
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
			if GradientManager.purchasedGradients[GradientManager.premiumList[selected.row].name] != nil {
				return
			} else {
				if NetworkMonitor.connection {
					
					var isAuthorizedForPayments = SKPaymentQueue.canMakePayments()
					
					if isAuthorizedForPayments && !products.isEmpty {
						StoreObserver.iapObserver.buy(products[selected.row])
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
