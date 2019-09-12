//
//  NetworkMonitor.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 9/12/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import Network

struct NetworkMonitor {
	
	static let monitor = NWPathMonitor()
	static var connection = true
}
