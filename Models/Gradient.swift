//
//  Gradient.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 9/13/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct Gradient: Codable {
	var name: String
	
	var firstDirection: String
	var secondDirection: String
	var thirdDirection: String
	var fourthDirection: String
	
	var first: [String]
	var second: [String]
	var third: [String]
	var fourth: [String]
}
