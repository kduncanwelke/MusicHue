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
	func setGradientBackground(colorTop: UIColor, colorBottom: UIColor){
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
		gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
		gradientLayer.frame = self.bounds
		
		self.layer.insertSublayer(gradientLayer, at: 0)
	}
}
