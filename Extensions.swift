//
//  Extensions.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 8/20/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	// animate buttons with press animation
	func animateButton() {
		UIView.animate(withDuration: 0.2, animations: {
			self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
		}, completion: { [unowned self] _ in
			UIView.animate(withDuration: 0.2) {
				self.transform = CGAffineTransform.identity
			}
		})
	}
	
	func pressDown() {
		UIView.animate(withDuration: 0.2, animations: {
			self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
		})
	}
	
	func popUp() {
		UIView.animate(withDuration: 0.2, animations: {
			self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
		})
	}
}
