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
import CoreData

class ViewController: UIViewController {
	
	// MARK: IBOutlets
	
	@IBOutlet weak var background: UIView!
	
	@IBOutlet weak var selectMusicButton: UIButton!
	@IBOutlet weak var viewPlaylistButton: UIButton!
	@IBOutlet weak var colorButton: UIButton!
	
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
		
		NotificationCenter.default.addObserver(self, selector: #selector(songChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: mediaPlayer)
		
		NotificationCenter.default.addObserver(self, selector: #selector(stateChanged), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: mediaPlayer)
		
		NotificationCenter.default.addObserver(self, selector: #selector(newSong), name: NSNotification.Name(rawValue: "newSong"), object: nil)
		
		selectMusicButton.layer.cornerRadius = 10
		viewPlaylistButton.layer.cornerRadius = 10
		colorButton.layer.cornerRadius = 10
		checkStatus()
		
		mediaPlayer.repeatMode = .none
		mediaPlayer.shuffleMode = .off
		
		checkForNowPlaying()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		let animatedGradient = AnimatedGradientView(frame: view.bounds)
		animatedGradient.animationValues = GradientManager.currentGradient.color
		background.addSubview(animatedGradient)
	}
	
	override func becomeFirstResponder() -> Bool {
		return true
	}
	
	override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		if motion == .motionShake {
			print("Shake Gesture Detected")
			
			if mediaPlayer.repeatMode != .one && mediaPlayer.shuffleMode == .off {
				mediaPlayer.shuffleMode = .songs
				shuffleButton.setImage(UIImage(named: "shuffle"), for: .normal)
			} else if mediaPlayer.shuffleMode == .songs {
				mediaPlayer.shuffleMode = .off
				shuffleButton.setImage(UIImage(named: "shuffleoff"), for: .normal)
			}
		}
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
			var seconds = Int(mediaPlayer.currentPlaybackTime)
			let ms = (mediaPlayer.currentPlaybackTime.truncatingRemainder(dividingBy: 1)) * 1000
			if ms > 0.5 {
				seconds += 1
			}
			
			if seconds < 60 {
				if seconds < 10 {
					return "0:0\(seconds)"
				} else {
					return "0:\(seconds)"
				}
			} else if seconds >= 3600 {
				let hour = Int(seconds / 3600)
				let minute = Int((seconds - (hour * 3600)) / 60)
				let second = seconds % 60
				
				if minute < 10 {
					if second < 10 {
						return "\(hour):0\(minute):0\(second)"
					} else {
						return "\(hour):0\(minute):\(second)"
					}
				}
				
				if second < 10 {
					return "\(hour):\(minute):0\(second)"
				} else {
					return "\(hour):\(minute):\(second)"
				}
			} else {
				let minute = seconds / 60
				let second = seconds % 60
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
			TimerManager.beginTimer(with: mediaPlayer.currentPlaybackTime, maxTime: item.playbackDuration, label: timeLabel, bar: progress, isRepeating: doesRepeat)
			print(mediaPlayer.currentPlaybackTime)
		}
	}
	
	func checkForNowPlaying() {
		if mediaPlayer.nowPlayingItem == nil {
			save()
			print("now playing nil")
		} else {
			loadSongs()
			print("loaded")
		}
	}
	
	func checkStatus() {
		if mediaPlayer.nowPlayingItem == nil {
			currentlyPlaying.text = "No selection"
			artist.text = "No selection"
			albumArt.image = UIImage(named: "noimg")
			
			playPauseButton.isEnabled = false
			forwardButton.isEnabled = false
			backButton.isEnabled = false
			repeatButton.isEnabled = false
			shuffleButton.isEnabled = false
		} else {
			playPauseButton.isEnabled = true
			forwardButton.isEnabled = true
			backButton.isEnabled = true
			repeatButton.isEnabled = true
			shuffleButton.isEnabled = true
			
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
	
	@objc func stateChanged() {
		if mediaPlayer.playbackState == .playing {
			playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
			
			TimerManager.stopTimer()
			
			if mediaPlayer.repeatMode == .one {
				startTimer(doesRepeat: true)
			} else {
				startTimer(doesRepeat: false)
			}
		} else if mediaPlayer.playbackState == .paused || mediaPlayer.playbackState == .stopped {
			playPauseButton.setImage(UIImage(named: "play"), for: .normal)
			TimerManager.stopTimer()
		}
	}
	
	@objc func newSong() {
		mediaPlayer.stop()
		mediaPlayer.nowPlayingItem = MusicManager.songs[MusicManager.selectedSong]
		mediaPlayer.play()
	}
	
	func save() {
		var managedContext = CoreDataManager.shared.managedObjectContext
		
		if let existing = MusicManager.playlist {
			var idList: [String] = []
			
			for song in MusicManager.songs {
				idList.append("\(song.persistentID)")
			}
			
			print("old save")
			print(idList)
			existing.songs = idList
			
			do {
				try managedContext.save()
				print("saved")
				//NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
			} catch {
				// this should never be displayed but is here to cover the possibility
				//showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
				print("fail")
			}
		} else {
			let savedPlaylist = Playlist(context: managedContext)
			
			var idList: [String] = []
			
			for song in MusicManager.songs {
				idList.append("\(song.persistentID)")
			}
			
			print("new save")
			print(idList)
			savedPlaylist.songs = idList
			MusicManager.playlist = savedPlaylist
			
			do {
				try managedContext.save()
				print("saved")
				//NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
			} catch {
				// this should never be displayed but is here to cover the possibility
				//showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
				print("fail")
			}
		}
		
	}
	
	func loadSongs() {
		var managedContext = CoreDataManager.shared.managedObjectContext
		var fetchRequest = NSFetchRequest<Playlist>(entityName: "Playlist")
		
		do {
			var list = try managedContext.fetch(fetchRequest)
			
			MusicManager.playlist = list.first
			
			if let playlist = MusicManager.playlist?.songs {
				var retrievedSongs: [MPMediaItem] = []
				
				for song in playlist {
					print(song)
					let predicate = MPMediaPropertyPredicate(value: song, forProperty: MPMediaItemPropertyPersistentID)
					let songQuery = MPMediaQuery.init(filterPredicates: [predicate])
					
					if let items = songQuery.items, items.count > 0 {
						retrievedSongs.append(items[0])
					}
				}
				
				MusicManager.songs = retrievedSongs
			}
			
			print("music loaded")
		} catch let error as NSError {
			//showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
			print("fail")
		}
	}
	
	// MARK: IBActions
	
	@IBAction func changeColor(_ sender: UIButton) {
		performSegue(withIdentifier: "changeColor", sender: Any?.self)
	}
	
	
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
			
			if mediaPlayer.playbackState == .playing {
				startTimer(doesRepeat: false)
			}
		} else if sender.state == .began {
			TimerManager.stopTimer()
			backButton.pressDown()
			mediaPlayer.beginSeekingBackward()
		} else {
			updateTimeLabel()
			updateProgress()
		}
	}
	
	@IBAction func playPausePressed(_ sender: UIButton) {
		playPauseButton.animateButton()
		
		if mediaPlayer.playbackState == .playing {
			mediaPlayer.pause()
		} else if mediaPlayer.playbackState == .paused || mediaPlayer.playbackState == .stopped {
			mediaPlayer.play()
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
			
			if mediaPlayer.playbackState == .playing {
				startTimer(doesRepeat: false)
			}
		} else if sender.state == .began {
			TimerManager.stopTimer()
			forwardButton.pressDown()
			mediaPlayer.beginSeekingForward()
		} else {
			updateTimeLabel()
			updateProgress()
		}
	}
	
	@IBAction func changeRepeat(_ sender: UIButton) {
		repeatButton.animateButton()
		
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
		shuffleButton.animateButton()
		
		if mediaPlayer.shuffleMode == .off {
			mediaPlayer.shuffleMode = .songs
			shuffleButton.setImage(UIImage(named: "shuffle"), for: .normal)
		} else if mediaPlayer.shuffleMode == .songs {
			mediaPlayer.shuffleMode = .off
			shuffleButton.setImage(UIImage(named: "shuffleoff"), for: .normal)
		}
	}
	
	@IBAction func viewPlaylistPressed(_ sender: UIButton) {
		performSegue(withIdentifier: "viewSongs", sender: Any?.self)
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
		
		if MusicManager.songs.isEmpty {
			mediaPlayer.play()
		}
		
		for item in mediaItemCollection.items {
			MusicManager.songs.append(item)
			print(item.title)
			print(item.persistentID)
		}
		
		save()
		
		mediaPicker.dismiss(animated: true, completion: nil)
		
		//checkStatus()
	}
	
	func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
		mediaPicker.dismiss(animated: true, completion: nil)
		checkStatus()
	}
}
