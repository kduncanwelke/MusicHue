//
//  GradientManager.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 8/24/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import AnimatedGradientView

struct GradientManager {
	
	static var currentGradient = colorList[0]
	
	static let colorList = [
	
		Color(name: ColorName.automatic, description: "The classic theme", color:
			[(colors: ["#fbe865", "#65f2fb"], .right, .axial),
			(colors: ["#65fb85", "#fbcb65"], .down, .axial),
			(colors: ["#f665fb", "#cf65fb"], .left, .axial),
			(colors: ["#fb65a5", "#fbb665"], .up, .axial)])
		,
		Color(name: ColorName.arctic, description: "Chilly tundra tones", color:
			[(colors: ["#c8f4f6", "#e7feff"], .right, .axial),
			(colors: ["#baf3ff", "#81e9ff"], .down, .axial),
			(colors: ["#edfdff", "#b1f3f5"], .left, .axial),
			(colors: ["#5ceff3", "#d9feff"], .up, .axial)])
		,
		Color(name: ColorName.nebula, description: "Space dust hues", color:
			[(colors: ["#703aac", "#371859"], .down, .axial),
			 (colors: ["#b618b0", "#2b18b6"], .right, .axial),
			 (colors: ["#473562", "#1a2075"], .up, .axial),
			 (colors: ["#3f2560", "#614683"], .left, .axial)])
		,
		Color(name: ColorName.sea, description: "Cooling ocean vibes",  color:
			[(colors: ["#30379a", "#0e145f"], .right, .axial),
			 (colors: ["#3c64d6", "#78b5f9"], .down, .axial),
			 (colors: ["#a6e5ff", "#c7f2ff"], .right, .axial),
			 (colors: ["#39c5ed", "#57aec7"], .down, .axial)])
		,
		Color(name: ColorName.rainbow, description: "All your colors",  color:
			[(colors: ["#da39ed", "#ed3939"], .upRight, .axial),
			 (colors: ["#ed9f39", "#edcd39"], .upLeft, .axial),
			 (colors: ["#39ed45", "#39ede7"], .upRight, .axial),
			 (colors: ["#3989ed", "#8e39ed"], .upLeft, .axial)])
		,
		Color(name: ColorName.sunlight, description: "A sunny day",  color:
			[(colors: ["#e59b1a", "#e5c61a"], .downLeft, .axial),
			 (colors: ["#ffe139", "#fff09a"], .down, .axial),
			 (colors: ["#ffdf9a", "#f5bd46"], .downRight, .axial),
			 (colors: ["#fdad00", "#fdd000"], .down, .axial)])
		,
		Color(name: ColorName.forest, description: "Feel the photosynthesis",  color:
			[(colors: ["#22955b", "#0a7c50"], .right, .axial),
			 (colors: ["#2b5444", "#2a7c3f"], .upLeft, .axial),
			 (colors: ["#249842", "#4a9824"], .right, .axial),
			 (colors: ["#76c251", "#308d55"], .upLeft, .axial)])
		,
		Color(name: ColorName.sunset, description: "Sun getting low",  color:
			[(colors: ["#603f76", "#74763f"], .down, .axial),
			 (colors: ["#895e13", "#d08400"], .down, .axial),
			 (colors: ["#ecda11", "#ec8211"], .down, .axial),
			 (colors: ["#ec3f11", "#80341f"], .down, .axial)])
		,
		Color(name: ColorName.sunrise, description: "Early morning vibes",  color:
			[(colors: ["#5663b5", "#5697b5"], .up, .axial),
			 (colors: ["#a6b556", "#d3bb49"], .up, .axial),
			 (colors: ["#e29823", "#e28123"], .up, .axial),
			 (colors: ["#caad28", "#a3d2ed"], .up, .axial)])
		,
		Color(name: ColorName.fire, description: "Warm and lively",  color:
			[(colors: ["#ca440a", "#e24500"], .upRight, .axial),
			 (colors: ["#e27a00", "#e2bf00"], .left, .axial),
			 (colors: ["#ffe659", "#fff3ae"], .downLeft, .axial),
			 (colors: ["#eafeff", "#f0bb77"], .up, .axial)])
		,
		Color(name: ColorName.desert, description: "Calming dusty hues",  color:
			[(colors: ["#d8b333", "#ead075"], .right, .axial),
			 (colors: ["#cce0e1", "#aee3da"], .down, .axial),
			 (colors: ["#e3e0ae", "#c0ab57"], .right, .axial),
			 (colors: ["#e1cd7c", "#c2b78a"], .up, .axial)])
		,
		Color(name: ColorName.pastel, description: "Something sweet",  color:
			[(colors: ["#a6e7b2", "#a6e7d4"], .left, .axial),
			 (colors: ["#a6cbe7", "#ada6e7"], .upRight, .axial),
			 (colors: ["#e2a6e7", "#e7d4a6"], .down, .axial),
			 (colors: ["#e7e3a6", "#cbe7a6"], .right, .axial)])
		,
		Color(name: ColorName.space, description: "Deep outer limits",  color:
			[(colors: ["#262437", "#202b46"], .upRight, .axial),
			 (colors: ["#1b165f", "#453664"], .down, .axial),
			 (colors: ["#291640", "#1b2630"], .left, .axial),
			 (colors: ["#082c4c", "#131619"], .upLeft, .axial)])
		,
		Color(name: ColorName.sky, description: "Time for cloudgazing",  color:
			[(colors: ["#0a98e1", "#5ac5fc"], .down, .axial),
			 (colors: ["#bee9ff", "#bef0ff"], .left, .axial),
			 (colors: ["#e2f9ff", "#20b5e6"], .up, .axial),
			 (colors: ["#0067a9", "#69a2c6"], .right, .axial)])
		,
		Color(name: ColorName.spring, description: "Cheery springtime hues",  color:
			[(colors: ["#3dd279", "#cde94a"], .right, .axial),
			 (colors: ["#e1ff9a", "#ffbefd"], .upRight, .axial),
			 (colors: ["#88eff5", "#889ff5"], .upLeft, .axial),
			 (colors: ["#7eb4fd", "#41d6a0"], .down, .axial)])
		,
		Color(name: ColorName.metal, description: "Bold and shiny",  color:
			[(colors: ["#3e3e41", "#75757b"], .down, .axial),
			 (colors: ["#41424d", "#15161a"], .downRight, .axial),
			 (colors: ["#5f5f61", "#b7b7b7"], .down, .axial),
			 (colors: ["#dcdcdc", "#878787"], .downLeft, .axial)])
		,
		Color(name: ColorName.coffee, description: "Toasted espresso beans",  color:
			[(colors: ["#774a32", "#542c16"], .down, .axial),
			 (colors: ["#3a261a", "#503a2e"], .downLeft, .axial),
			 (colors: ["#5f2f15", "#92593a"], .down, .axial),
			 (colors: ["#966951", "#7c4628"], .downRight, .axial)])
		,
		Color(name: ColorName.unicorn, description: "Bright and shiny",  color:
			[(colors: ["#2a54dd", "#2ac6dd"], .up, .axial),
			 (colors: ["#bff7ff", "#f4bfff"], .left, .axial),
			 (colors: ["#f07af7", "#df32ea"], .down, .axial),
			 (colors: ["#fcfbb8", "#f5f353"], .right, .axial)])
		,
		Color(name: ColorName.complements, description: "Opposites go together",  color:
			[(colors: ["#f38300", "#000bf3"], .up, .axial),
			 (colors: ["#9500f3", "#f3f000"], .up, .axial),
			 (colors: ["#0bf300", "#f30000"], .up, .axial)])
		,
		Color(name: ColorName.pink, description: "In the pink",  color:
			[(colors: ["#ed1cef", "#fc6ffe"], .upRight, .axial),
			 (colors: ["#fe9fff", "#fec3ff"], .up, .axial),
			 (colors: ["#f18bf2", "#d752d9"], .upLeft, .axial),
			 (colors: ["#ce21d0", "#d902dc"], .up, .axial)])
	]
}
