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
	
	// manage which gradient is currently in use
	static var currentGradientName: ColorName = ColorName.automatic
	static var currentGradient = colorList[ColorName.automatic]

	// list of free colors
	static let colorList: [ColorName: [AnimatedGradientView.AnimationValue]] = [
	
		ColorName.automatic:
			[(colors: ["#fbe865", "#65f2fb"], .right, .axial),
			(colors: ["#65fb85", "#fbcb65"], .down, .axial),
			(colors: ["#f665fb", "#cf65fb"], .left, .axial),
			(colors: ["#fb65a5", "#fbb665"], .up, .axial)]
		,
		ColorName.arctic:
			[(colors: ["#4FC4E8", "#7CD3EE", "#7CE5EE"], .right, .axial),
			(colors: ["#7CE5EE", "#B7F5F6", "#D4F3F7"], .downRight, .axial),
			(colors: ["#D4F3F7", "#D4E7F7", "#7FBAEB"], .down, .axial),
			(colors: ["#7FBAEB", "#65A6E7", "#4FC4E8"], .downRight, .axial)]
		,
		ColorName.sea:
			[(colors: ["#1A5FAD", "#2D99EB", "#52ABEF"], .left, .axial),
			 (colors: ["#52ABEF", "#52CDEF", "#36BDE2"], .down, .axial),
			 (colors: ["#36BDE2", "#2AA4C6", "#3C64D6"], .downRight, .axial),
			 (colors: ["#3C64D6", "#30379A", "#1A5FAD"], .downLeft, .axial)]
		,
		ColorName.sunlight:
			[(colors: ["#FFE838", "#FFEB52", "#fff399"], .downLeft, .axial),
			 (colors: ["#fff399", "#FFDB4D", "#FFCE47"], .down, .axial),
			 (colors: ["#FFCE47", "#FFE066", "#FFCB52"], .downRight, .axial),
			 (colors: ["#FFCB52", "#ffdc42", "#FFE838"], .down, .axial)]
		,
		ColorName.forest:
			[(colors: ["#21BA63", "#21834B", "#259372"], .left, .axial),
			 (colors: ["#259372", "#0F693B", "#094627"], .downLeft, .axial),
			 (colors: ["#094627", "#036332", "#03781F"], .down, .axial),
			 (colors: ["#03781F", "#078E43", "#08B956"], .downLeft, .axial)]
		,
		ColorName.sunset:
			[(colors: ["#603f76", "#74763f", "#895e13"], .up, .axial),
			 (colors: ["#895e13", "#d08400", "#ecda11"], .up, .axial),
			 (colors: ["#ecda11", "#ec8211", "#ec3f11"], .up, .axial),
			 (colors: ["#ec3f11", "#80341f", "#603f76"], .up, .axial)]
		,
		ColorName.sunrise:
			[(colors: ["#5663b5", "#5697b5", "#a6b556"], .down, .axial),
			 (colors: ["#a6b556", "#d3bb49", "#e29823"], .down, .axial),
			 (colors: ["#e29823", "#e28123", "#caad28"], .down, .axial),
			 (colors: ["#caad28", "#a3d2ed", "#5663b5"], .down, .axial)]
		,
		ColorName.sky:
			[(colors: ["#0a98e1", "#5ac5fc", "#bee9ff"], .up, .axial),
			 (colors: ["#bee9ff", "#bef0ff", "#e2f9ff"], .left, .axial),
			 (colors: ["#e2f9ff", "#20b5e6", "#0067a9"], .up, .axial),
			 (colors: ["#0067a9", "#69a2c6", "#0a98e1"], .upRight, .axial)]
		,
		ColorName.mesa:
			[(colors: ["#E65C0D", "#D20E01", "#C8001D"], .up, .axial),
			 (colors: ["#C8001D", "#AF023C", "#84042F"], .up, .axial),
			 (colors: ["#84042F", "#970707", "#621D09"], .up, .axial),
			 (colors: ["#621D09", "#3F120D", "#201513"], .up, .axial)]
		,
		ColorName.complements:
			[(colors: ["#f38300", "#000bf3"], .up, .axial),
			 (colors: ["#9500f3", "#f3f000"], .up, .axial),
			 (colors: ["#0bf300", "#f30000"], .up, .axial)]
	]
	
	// static previews of colors
	static let colorPreviews = [
		
		Color(name: ColorName.automatic, description: "The classic theme", color:
			[(colors: ["#fbe865", "#65f2fb"], .right, .axial)])
		,
		Color(name: ColorName.arctic, description: "Chilly tundra tones", color:
			[(colors: ["#4FC4E8", "#7CD3EE", "#7CE5EE"], .right, .axial)])
		,
		Color(name: ColorName.complements, description: "Opposites go together",  color:
			[(colors: ["#f38300", "#000bf3"], .up, .axial)])
		,
		Color(name: ColorName.forest, description: "Cool, calming woods",  color:
			[(colors: ["#21BA63", "#21834B", "#259372"], .left, .axial)])
		,
		Color(name: ColorName.mesa, description: "Rusty hues", color: [(colors: ["#E65C0D", "#D20E01", "#C8001D"], .up, .axial)])
		,
		Color(name: ColorName.sea, description: "Cooling ocean vibes",  color:
			[(colors: ["#1A5FAD", "#2D99EB", "#52ABEF"], .left, .axial)])
		,
		Color(name: ColorName.sky, description: "Cloudgazing",  color:
			[(colors: ["#0a98e1", "#5ac5fc", "#bee9ff"], .up, .axial)])
		,
		Color(name: ColorName.sunlight, description: "A sunny day",  color:
			[(colors: ["#FFE838", "#FFEB52", "#fff399"], .downLeft, .axial)])
		,
		Color(name: ColorName.sunrise, description: "Early morning vibes",  color:
			[(colors: ["#5663b5", "#5697b5", "#a6b556"], .down, .axial)])
		,
		Color(name: ColorName.sunset, description: "Sun getting low",  color:
			[(colors: ["#ec3f11", "#80341f", "#603f76"], .up, .axial)])
	]
	
	// static preview of premium colors
	static var premiumList = [
		Color(name: ColorName.fall, description: "Autumn leaves",  color:
			[(colors: ["#A25916", "#DC5009", "#F59B14"], .down, .axial)])
		,
		Color(name: ColorName.fire, description: "Warm and lively",  color:
			[(colors: ["#F56D29", "#F5A029", "#F5C929"], .downRight, .axial)])
		,
		Color(name: ColorName.mountain, description: "Calming dusky hues",  color:
			[(colors: ["#9960D2", "#6960D2", "#5565DD"], .right, .axial)])
		,
		Color(name: ColorName.nebula, description: "Space dust hues", color:
			[(colors: ["#331551", "#54185D", "#872796"], .down, .axial)])
		,
		Color(name: ColorName.pastel, description: "Something sweet",  color:
			[(colors: ["#97f7a8", "#97f7da", "#97cdf7"], .left, .axial)])
		,
		Color(name: ColorName.rainbow, description: "All your colors",  color:
			[(colors: ["#da39ed", "#ed3939", "#ed9f39"], .downRight, .axial)])
		,
		Color(name: ColorName.space, description: "Deep outer limits",  color:
			[(colors: ["#242E70", "#152542", "#38417A"], .down, .axial)])
		,
		Color(name: ColorName.spring, description: "Springtime hues",  color:
			[(colors: ["#3dd279", "#cde94a", "#e1ff9a"], .up, .axial)])
		,
		Color(name: ColorName.summer, description: "Bright and sunny",  color:
			[(colors: ["#FCD173", "#FCB582", "#FEBED4"], .down, .axial)])
		,
		Color(name: ColorName.triads, description: "Harmonies of three", color: [(colors: ["#DED81F", "#1FDED8", "#D81FDE"], .downLeft, .axial)])
		,
		Color(name: ColorName.unicorn, description: "Saturated fantasy",  color:
			[(colors: ["#2a54dd", "#2ac6dd"], .up, .axial)])
		,
		Color(name: ColorName.winter, description: "Chilly snow",  color:
			[(colors: ["#88A7F6", "#8CC6F2", "#8CC6F2"], .right, .axial)])
	]
	
	// manage saves and purchases
	static var gradientToSave: Gradient?
	static var purchasedGradients: [ColorName: [AnimatedGradientView.AnimationValue]] = [:]
	
	
	// MARK: methods
	
	// get direction for animatedgradient from string
	static func convertToDirection(direction: String) -> AnimatedGradientView.Direction? {
		if direction == "up" {
			return .up
		} else if direction == "down" {
			return .down
		} else if direction == "right" {
			return .right
		} else if direction == "left" {
			return .left
		} else if direction == "downRight" {
			return .downRight
		} else if direction == "downLeft" {
			return .downLeft
		} else if direction == "upRight" {
			return .upRight
		} else if direction == "upLeft" {
			return .upLeft
		} else {
			return nil
		}
	}
	
	static func getColor(from color: String) -> ColorName {
		if color == "Unicorn" {
			return ColorName.unicorn
		} else if color == "Nebula" {
			return ColorName.nebula
		} else if color == "Rainbow" {
			return ColorName.rainbow
		} else if color == "Mountain" {
			return ColorName.mountain
		} else if color == "Pastel" {
			return ColorName.pastel
		} else if color == "Space" {
			return ColorName.space
		} else if color == "Fire" {
			return ColorName.fire
		} else if color == "Spring" {
			return ColorName.spring
		} else if color == "Summer" {
			return ColorName.summer
		} else if color == "Fall" {
			return ColorName.fall
		} else if color == "Winter" {
			return ColorName.winter
		} else if color == "Triads" {
			return ColorName.triads
		} else {
			return .automatic
		}
	}
	
	// convert purchased gradient into color object
	static func addToPurchased(loaded: Gradient) {
		if let first = GradientManager.convertToDirection(direction: loaded.firstDirection), let second = GradientManager.convertToDirection(direction: loaded.secondDirection), let third = GradientManager.convertToDirection(direction: loaded.thirdDirection), let fourth = GradientManager.convertToDirection(direction: loaded.fourthDirection) {
			
			let premiumGradient: [AnimatedGradientView.AnimationValue] = [(colors: loaded.first, first, .axial), (colors: loaded.second, second, .axial), (colors: loaded.third, third, .axial),(colors: loaded.fourth, fourth, .axial)]
			
			let color = getColor(from: loaded.name)
			
			GradientManager.purchasedGradients.updateValue(premiumGradient, forKey: color)
		}
	}
	
	// convert purchased savedgradient loaded from core data into color object
	static func addToPurchased(loaded: SavedGradient) {
		if let firstDirection = loaded.firstDirection, let secondDirection = loaded.secondDirection, let thirdDirection = loaded.thirdDirection, let fourthDirection = loaded.fourthDirection, let first = GradientManager.convertToDirection(direction: firstDirection), let second = GradientManager.convertToDirection(direction: secondDirection), let third = GradientManager.convertToDirection(direction: thirdDirection), let fourth = GradientManager.convertToDirection(direction: fourthDirection), let firstColors = loaded.firstColorSet, let secondColors = loaded.secondColorSet, let thirdColors = loaded.thirdColorSet, let fourthColors = loaded.fourthColorSet, let name = loaded.name {
			
			let premiumGradient: [AnimatedGradientView.AnimationValue] = [(colors: firstColors, first, .axial), (colors: secondColors, second, .axial), (colors: thirdColors, third, .axial),(colors: fourthColors, fourth, .axial)]
			
			let color = getColor(from: name)
			
			GradientManager.purchasedGradients.updateValue(premiumGradient, forKey: color)
		}
	}
}
