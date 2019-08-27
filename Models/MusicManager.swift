//
//  MusicManager.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 8/23/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import MediaPlayer

struct MusicManager {
	static var songs: [MPMediaItem] = []
	
	static var selectedSong = 0
	
	static var playlist: Playlist?
}
