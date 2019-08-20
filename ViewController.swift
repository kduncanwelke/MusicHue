//
//  ViewController.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 8/20/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import AnimatedGradientView
import MediaPlayer

class ViewController: UIViewController {
	
	// MARK: IBOutlets
	
	@IBOutlet weak var background: UIView!
	@IBOutlet weak var selectMusicButton: UIButton!
	@IBOutlet weak var playPauseButton: UIButton!
	@IBOutlet weak var currentlyPlaying: UILabel!
	
	
	// MARK: Variables
	
	let mediaPlayer = MPMusicPlayerController.systemMusicPlayer

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		selectMusicButton.layer.cornerRadius = 10
		checkStatus()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		let animatedGradient = AnimatedGradientView(frame: view.bounds)
		animatedGradient.animationValues = [(colors: ["#fbe865", "#65f2fb"], .right, .axial),
											(colors: ["#65fb85", "#fbcb65"], .down, .axial),
											(colors: ["#f665fb", "#cf65fb"], .left, .axial),
											(colors: ["#fb65a5", "#fbb665"], .up, .axial)]
		background.addSubview(animatedGradient)
	}
	
	// MARK: Custom functions
	
	func checkStatus() {
		if mediaPlayer.nowPlayingItem == nil {
			playPauseButton.isEnabled = false
		} else {
			playPauseButton.isEnabled = true
			currentlyPlaying.text = mediaPlayer.nowPlayingItem?.title
			
			if mediaPlayer.playbackState == .playing {
				playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
			}  else if mediaPlayer.playbackState == .paused || mediaPlayer.playbackState == .stopped {
				playPauseButton.setImage(UIImage(named: "play"), for: .normal)
			}
		}
	}
	
	
	// MARK: IBActions
	
	@IBAction func playPausePressed(_ sender: UIButton) {
		if mediaPlayer.playbackState == .playing {
			mediaPlayer.pause()
			playPauseButton.setImage(UIImage(named: "play"), for: .normal)
		} else if mediaPlayer.playbackState == .paused {
			mediaPlayer.play()
			playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
		}
	}
	
	@IBAction func selectMusicPressed(_ sender: UIButton) {
		let myMediaPickerVC = MPMediaPickerController(mediaTypes: MPMediaType.music)
		myMediaPickerVC.allowsPickingMultipleItems = true
		myMediaPickerVC.popoverPresentationController?.sourceView = sender
		myMediaPickerVC.delegate = self
		self.present(myMediaPickerVC, animated: true, completion: nil)
	}
}


// music picker extension
extension ViewController: MPMediaPickerControllerDelegate {
	func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
		mediaPlayer.setQueue(with: mediaItemCollection)
		mediaPicker.dismiss(animated: true, completion: nil)
		mediaPlayer.play()
		checkStatus()
	}
	
	func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
		mediaPicker.dismiss(animated: true, completion: nil)
		checkStatus()
	}
}
