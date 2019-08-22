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

	static func beginTimer(with currentProgress: Int, maxTime: Int, label: UILabel, bar: UIProgressView, isRepeating: Bool) {
		time = maxTime
		seconds = currentProgress
		repeating = isRepeating
		
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
			print("Timer fired!")
			seconds += 1
			
			if seconds < 60 {
				if seconds < 10 {
					label.text = "0:0\(seconds)"
				} else {
					label.text = "0:\(Int(seconds))"
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
	}
	
}
