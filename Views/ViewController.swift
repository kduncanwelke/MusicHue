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
	@IBOutlet weak var artist: UILabel!
	@IBOutlet weak var forwardButton: UIButton!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var albumArt: UIImageView!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var progress: UIProgressView!
	@IBOutlet weak var repeatButton: UIButton!
	@IBOutlet weak var shuffleButton: UIButton!
	
	// MARK: Variables
	
	let mediaPlayer = MPMusicPlayerController.systemMusicPlayer

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		mediaPlayer.beginGeneratingPlaybackNotifications()
		
		NotificationCenter.default.addObserver(self, selector: #selector(songChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: mediaPlayer
		)
		
		selectMusicButton.layer.cornerRadius = 10
		checkStatus()
		
		mediaPlayer.repeatMode = .none
		mediaPlayer.shuffleMode = .off
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
	
	func setUI() {
		currentlyPlaying.text = mediaPlayer.nowPlayingItem?.title
		artist.text = mediaPlayer.nowPlayingItem?.albumArtist
		albumArt.image = mediaPlayer.nowPlayingItem?.artwork?.image(at: albumArt.bounds.size)
		
		updateTimeLabel()
		updateProgress()
	}
	
	func updateTimeLabel() {
		timeLabel.text = {
			if Int(mediaPlayer.currentPlaybackTime) < 60 {
				if Int(mediaPlayer.currentPlaybackTime) < 10 {
					return "0:0\(Int(mediaPlayer.currentPlaybackTime))"
				} else {
					return "0:\(Int(Int(mediaPlayer.currentPlaybackTime)))"
				}
			} else {
				let minute = Int(mediaPlayer.currentPlaybackTime) / 60
				let second = Int(mediaPlayer.currentPlaybackTime) % 60
				if second < 10 {
					return "\(minute):0\(second)"
				} else {
					return "\(minute):\(second)"
				}
			}
		}()
	}
	
	func updateProgress() {
		if mediaPlayer.currentPlaybackTime > 0 {
			if let current = mediaPlayer.nowPlayingItem {
				let prog = mediaPlayer.currentPlaybackTime / current.playbackDuration
				let float = Float(prog)
				progress.setProgress(float, animated: false)
			} else {
				progress.setProgress(0.0, animated: false)
			}
		}
	}
	
	func startTimer(doesRepeat: Bool) {
		if let item = mediaPlayer.nowPlayingItem {
			let duration = Int(item.playbackDuration)
			TimerManager.beginTimer(with: Int(mediaPlayer.currentPlaybackTime), maxTime: duration, label: timeLabel, bar: progress, isRepeating: doesRepeat)
		}
	}
	
	func checkStatus() {
		if mediaPlayer.nowPlayingItem == nil {
			playPauseButton.isEnabled = false
			forwardButton.isEnabled = false
			backButton.isEnabled = false
			repeatButton.isEnabled = false
		} else {
			playPauseButton.isEnabled = true
			forwardButton.isEnabled = true
			backButton.isEnabled = true
			repeatButton.isEnabled = true
			
			setUI()
			
			if mediaPlayer.playbackState == .playing {
				playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
			}  else if mediaPlayer.playbackState == .paused || mediaPlayer.playbackState == .stopped {
				playPauseButton.setImage(UIImage(named: "play"), for: .normal)
			}
		}
	}
	
	@objc func songChanged() {
		print("song changed")
		checkStatus()
		timeLabel.text = "0:00"
		progress.setProgress(0.0, animated: false)
		
		TimerManager.stopTimer()
		
		if mediaPlayer.playbackState == .playing {
			startTimer(doesRepeat: false)
		}
	}
	
	// MARK: IBActions
	
	@IBAction func backTap(_ sender: UITapGestureRecognizer) {
		backButton.animateButton()
		mediaPlayer.skipToPreviousItem()
		TimerManager.stopTimer()
	}
	
	@IBAction func backLongPress(_ sender: UILongPressGestureRecognizer) {
		if sender.state == .ended {
			mediaPlayer.endSeeking()
			backButton.popUp()
			checkStatus()
			startTimer(doesRepeat: false)
		} else if sender.state == .began {
			TimerManager.stopTimer()
			backButton.pressDown()
		} else {
			mediaPlayer.beginSeekingBackward()
			updateTimeLabel()
			updateProgress()
		}
	}
	
	@IBAction func playPausePressed(_ sender: UIButton) {
		playPauseButton.animateButton()
		if mediaPlayer.playbackState == .playing {
			mediaPlayer.pause()
			playPauseButton.setImage(UIImage(named: "play"), for: .normal)
			TimerManager.stopTimer()
		} else if mediaPlayer.playbackState == .paused || mediaPlayer.playbackState == .stopped {
			mediaPlayer.play()
			playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
			
			if mediaPlayer.repeatMode == .one {
				startTimer(doesRepeat: true)
			} else {
				startTimer(doesRepeat: false)
			}
		}
	}
	
	@IBAction func forwardTap(_ sender: UITapGestureRecognizer) {
		forwardButton.animateButton()
		mediaPlayer.skipToNextItem()
		TimerManager.stopTimer()
	}
	
	@IBAction func forwardLongPress(_ sender: UILongPressGestureRecognizer) {
		if sender.state == .ended {
			mediaPlayer.endSeeking()
			forwardButton.popUp()
			checkStatus()
			startTimer(doesRepeat: false)
		} else if sender.state == .began {
			TimerManager.stopTimer()
			forwardButton.pressDown()
		} else {
			mediaPlayer.beginSeekingForward()
			updateTimeLabel()
			updateProgress()
		}
	}
	
	@IBAction func changeRepeat(_ sender: UIButton) {
		switch mediaPlayer.repeatMode {
		case .none:
			mediaPlayer.repeatMode = .one
			repeatButton.setImage(UIImage(named: "repeatone"), for: .normal)
			
			TimerManager.stopTimer()
			if mediaPlayer.playbackState == .playing {
				startTimer(doesRepeat: true)
			}
			
			shuffleButton.setImage(UIImage(named: "shuffleoff"), for: .normal)
			mediaPlayer.shuffleMode = .off
			shuffleButton.isEnabled = false
		case .one:
			mediaPlayer.repeatMode = .all
			repeatButton.setImage(UIImage(named: "repeat"), for: .normal)
			
			shuffleButton.isEnabled = true
			
			TimerManager.stopTimer()
			if mediaPlayer.playbackState == .playing {
				startTimer(doesRepeat: false)
			}
		case .all:
			mediaPlayer.repeatMode = .none
			repeatButton.setImage(UIImage(named: "repeatoff"), for: .normal)
		default:
			break
		}
	}
	
	@IBAction func changeShuffle(_ sender: UIButton) {
		if mediaPlayer.shuffleMode == .off {
			mediaPlayer.shuffleMode = .songs
			shuffleButton.setImage(UIImage(named: "shuffle"), for: .normal)
		} else if mediaPlayer.shuffleMode == .songs {
			mediaPlayer.shuffleMode = .off
			shuffleButton.setImage(UIImage(named: "shuffleoff"), for: .normal)
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
