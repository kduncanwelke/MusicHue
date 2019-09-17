//
//  Color.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 8/24/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import AnimatedGradientView

struct Color {
	let name: ColorName
	let description: String
	let color: [AnimatedGradientView.AnimationValue]
}

enum ColorName: String {
	case automatic = "Automatic"
	case arctic = "Arctic"
	case nebula = "Nebula"
	case sea = "Sea"
	case rainbow = "Rainbow"
	case sunlight = "Sunlight"
	case forest = "Forest"
	case sunset = "Sunset"
	case sunrise = "Sunrise"
	case fire = "Fire"
	case mountain = "Mountain"
	case pastel = "Pastel"
	case space = "Space"
	case sky = "Sky"
	case spring = "Spring"
	case summer = "Summer"
	case fall = "Fall"
	case winter = "Winter"
	case unicorn = "Unicorn"
	case complements = "Complements"
	case triads = "Triads"
	case mesa = "Mesa"
}
