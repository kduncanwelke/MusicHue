//
//  TimerManager.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 8/21/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

class TimerManager {
	
	static var seconds = 0
	static var time = 0
	static var timer: Timer?
	static var repeating = false

	static func beginTimer(with currentProgress: TimeInterval, maxTime: TimeInterval, label: UILabel, bar: UIProgressView, isRepeating: Bool) {
		
		var fullTime = Int(maxTime)
		let ms = (maxTime.truncatingRemainder(dividingBy: 1)) * 1000
		if ms > 0.5 {
			fullTime += 1
		}
		
		var currentTime = Int(currentProgress)
		let currentms = (currentProgress.truncatingRemainder(dividingBy: 1)) * 1000
		
		time = fullTime
		seconds = currentTime
		repeating = isRepeating
		
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
			print("Timer fired!")
			seconds += 1
			print(seconds)
			if seconds < 60 {
				if seconds < 10 {
					label.text = "0:0\(seconds)"
				} else {
					label.text = "0:\(Int(seconds))"
				}
			} else if seconds >= 3600 {
				let hour = Int(seconds / 3600)
				let minute = Int((seconds - (hour * 3600)) / 60)
				let second = seconds % 60
				
				if minute < 10 {
					if second < 10 {
						label.text = "\(hour):0\(minute):0\(second)"
						print("sec")
					} else {
						label.text = "\(hour):0\(minute):\(second)"
						print("minute")
					}
				}
				
				if minute > 10 && second < 10 {
					label.text = "\(hour):\(minute):0\(second)"
				} else if minute > 10 && second > 10 {
					label.text = "\(hour):\(minute):\(second)"
				}
			} else {
				let minute = seconds / 60
				let second = seconds % 60
				if second < 10 {
					label.text = "\(minute):0\(second)"
				} else {
					label.text = "\(minute):\(second)"
				}
			}
	
			let floatTime = Float(time)
			let floatSec = Float(seconds)
			let progress = floatSec / floatTime
		
			bar.setProgress(progress, animated: true)
			
			if seconds == time {
				if repeating {
					seconds = 0
					label.text = "0:00"
					bar.setProgress(0.0, animated: false)
				} else {
					timer.invalidate()
					seconds = 0
				}
			}
		}
		
		timer?.fire()
	}
	
	static func stopTimer() {
		timer?.invalidate()
		seconds = 0
	}
	
}
