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


extension TimeInterval {
	func stringFromTimeInterval() -> String {
		
		var time = NSInteger(self)
		
		let ms = (self.truncatingRemainder(dividingBy: 1)) * 1000
		if ms > 0.5 {
			time += 1
		}
		let seconds = time % 60
		let minutes = (time / 60) % 60
		let hours = (time / 3600)
		
		if minutes == 0 {
			return String(format: "0:%0.2d",seconds)
		} else if hours == 0 {
			var result = String(format: "%0.2d:%0.2d",minutes,seconds)
			if result.first == "0" {
				return String(result.dropFirst())
			} else {
				return result
			}
		} else {
			var result = String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
			if result.first == "0" {
				return String(result.dropFirst())
			} else {
				return result
			}
		}
		
	}
		
}
