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
import Network

class ViewController: UIViewController {
	
	// MARK: IBOutlets
	
	@IBOutlet weak var background: UIView!
	
	@IBOutlet weak var selectMusicButton: UIButton!
	@IBOutlet weak var viewPlaylistButton: UIButton!
	@IBOutlet weak var colorButton: UIButton!
	@IBOutlet weak var textColorButton: UIButton!
	
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var playlistButton: UIButton!
	
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
	let monitor = NWPathMonitor()
	var connection = true
	var cloudItem = false
	var textColor = TextColor.white

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		 NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
		
		mediaPlayer.beginGeneratingPlaybackNotifications()
		
		NotificationCenter.default.addObserver(self, selector: #selector(songChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: mediaPlayer)
		
		NotificationCenter.default.addObserver(self, selector: #selector(stateChanged), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: mediaPlayer)
		
		NotificationCenter.default.addObserver(self, selector: #selector(newSong), name: NSNotification.Name(rawValue: "newSong"), object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(songDeleted), name: NSNotification.Name(rawValue: "songDeleted"), object: nil)
		
		
		selectMusicButton.layer.cornerRadius = 10
		viewPlaylistButton.layer.cornerRadius = 10
		colorButton.layer.cornerRadius = 10
		checkStatus()
		
		mediaPlayer.repeatMode = .none
		mediaPlayer.shuffleMode = .off
		
		loadPurchasedGradients()
		
		NetworkMonitor.monitor.pathUpdateHandler = { [unowned self] path in
			if path.status == .satisfied {
				print("connection successful")
				NetworkMonitor.connection = true
				NotificationCenter.default.post(name: NSNotification.Name(rawValue: "networkRestored"), object: nil)
			} else {
				print("no connection")
				NetworkMonitor.connection = false
				if let isAcloudItem = self.mediaPlayer.nowPlayingItem?.isCloudItem {
					if isAcloudItem {
						self.cloudItem = true
						
						DispatchQueue.main.async {
							self.checkStatus()
						}
					} else {
						self.cloudItem = false
					}
				}
			}
		}
		
		let queue = DispatchQueue(label: "Monitor")
		NetworkMonitor.monitor.start(queue: queue)
	}
	
	@objc func willEnterForeground() {
	}
	
	override func viewWillAppear(_ animated: Bool) {
		let animatedGradient = AnimatedGradientView(frame: view.bounds)
		animatedGradient.animationValues = GradientManager.currentGradient
		background.addSubview(animatedGradient)
		
		checkForNowPlaying()
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		switch textColor {
		case .white:
			return .lightContent
		case .black:
			return .default
		}
	}
	
	override func becomeFirstResponder() -> Bool {
		return true
	}
	
	// detect shake gesture for shuffle toggling
	override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		if motion == .motionShake {
			print("Shake Gesture Detected")
			
			if mediaPlayer.repeatMode != .one && mediaPlayer.shuffleMode == .off {
				mediaPlayer.shuffleMode = .songs
				
				switch textColor {
					case .white:
						shuffleButton.setImage(UIImage(named: "shuffle"), for: .normal)
					case .black:
						shuffleButton.setImage(UIImage(named: "shuffleblack"), for: .normal)
				}
			} else if mediaPlayer.shuffleMode == .songs {
				mediaPlayer.shuffleMode = .off
				
				switch textColor {
				case .white:
					shuffleButton.setImage(UIImage(named: "shuffleoff"), for: .normal)
				case .black:
					shuffleButton.setImage(UIImage(named: "shuffleoffblack"), for: .normal)
				}
			}
		}
	}
	
	// handle gradient display when orientation is changed
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		
		DispatchQueue.main.async {
			let animatedGradient = AnimatedGradientView(frame: self.view.bounds)
			animatedGradient.animationValues = GradientManager.currentGradient
			self.background.addSubview(animatedGradient)
		}
	}
	
	// MARK: Custom functions
	
	func setUI() {
		currentlyPlaying.text = mediaPlayer.nowPlayingItem?.title
		artist.text = mediaPlayer.nowPlayingItem?.albumArtist
		if let albumVisual = mediaPlayer.nowPlayingItem?.artwork?.image(at: albumArt.bounds.size) {
			albumArt.image = albumVisual
		} else {
			albumArt.image = UIImage(named: "noimage")
		}
		
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
		}
	}
	
	func checkForNowPlaying() {
		if mediaPlayer.nowPlayingItem == nil {
			MusicManager.songs.removeAll()
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
			artist.text = "-"
			albumArt.image = UIImage(named: "noimage")
			
			playPauseButton.isEnabled = false
			forwardButton.isEnabled = false
			backButton.isEnabled = false
			repeatButton.isEnabled = false
			shuffleButton.isEnabled = false
			
			print("check status nil")
			MusicManager.songs.removeAll()
		} else {
			if !MusicManager.songs.isEmpty {
				print("check status not nil")
				playPauseButton.isEnabled = true
				forwardButton.isEnabled = true
				backButton.isEnabled = true
				repeatButton.isEnabled = true
				shuffleButton.isEnabled = true
				
				setUI()
				
				if cloudItem && connection == false {
					mediaPlayer.pause()
					showAlert(title: "No network connection", message: "This song is streaming from the cloud - you may experience problems with playback until a data connection is restored.")
				} else {
					// nothing
				}
				
				if mediaPlayer.playbackState == .playing {
					switch textColor {
					case .white:
						playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
					case .black:
						playPauseButton.setImage(UIImage(named: "pauseblack"), for: .normal)
					}
					
				}  else if mediaPlayer.playbackState == .paused || mediaPlayer.playbackState == .stopped {
					switch textColor {
					case .white:
						playPauseButton.setImage(UIImage(named: "play"), for: .normal)
					case .black:
						playPauseButton.setImage(UIImage(named: "playblack"), for: .normal)
					}
					
				}
			} else {
				save()
			}
		}
	}
	
	@objc func songDeleted() {
		var collection = MPMediaItemCollection(items: MusicManager.songs)
	
		mediaPlayer.setQueue(with: collection)
		save()
		mediaPlayer.prepareToPlay()
	}
	
	@objc func songChanged() {
		print("song changed")
		checkStatus()
		timeLabel.text = "0:00"
		progress.setProgress(0.0, animated: false)
		
		TimerManager.stopTimer()
		
		//playPauseButton.isEnabled = true
		
		if mediaPlayer.playbackState == .playing {
			startTimer(doesRepeat: false)
		}
	}
	
	@objc func stateChanged() {
		if mediaPlayer.playbackState == .playing {
			switch textColor {
				case .white:
					playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
				case .black:
					playPauseButton.setImage(UIImage(named: "pauseblack"), for: .normal)
			}
			
			TimerManager.stopTimer()
			
			if mediaPlayer.repeatMode == .one {
				startTimer(doesRepeat: true)
			} else {
				startTimer(doesRepeat: false)
			}
		} else if mediaPlayer.playbackState == .paused || mediaPlayer.playbackState == .stopped {
			switch textColor {
			case .white:
				playPauseButton.setImage(UIImage(named: "play"), for: .normal)
			case .black:
				playPauseButton.setImage(UIImage(named: "playblack"), for: .normal)
			}
			
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
				print(song.title)
			}
			
			print(MusicManager.songs)
			print("old save")
			
			existing.songs = idList
			
			do {
				try managedContext.save()
				print("saved playlist")
				//NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
			} catch {
				// this should never be displayed but is here to cover the possibility
				showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
				print("fail")
			}
		} else {
			let savedPlaylist = Playlist(context: managedContext)
			
			var idList: [String] = []
			
			for song in MusicManager.songs {
				idList.append("\(song.persistentID)")
				print(song.title)
			}
			
			print("new save")
		
			savedPlaylist.songs = idList
			MusicManager.playlist = savedPlaylist
			
			do {
				try managedContext.save()
				print("saved playlist")
				//NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
			} catch {
				// this should never be displayed but is here to cover the possibility
				showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
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
			showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
			print("fail")
		}
	}
	
	func loadPurchasedGradients() {
		var managedContext = CoreDataManager.shared.managedObjectContext
		var fetchRequest = NSFetchRequest<SavedGradient>(entityName: "SavedGradient")
		
		do {
			var gradients = try managedContext.fetch(fetchRequest)
			
			for gradient in gradients {
				print(gradient)
				GradientManager.addToPurchased(loaded: gradient)
			}
			
			print("gradients loaded")
		} catch let error as NSError {
			showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
			print("fail")
		}
	}
	
	// MARK: IBActions
	
	@IBAction func changeColor(_ sender: UIButton) {
		colorButton.animateButton()
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
		
		if cloudItem && connection == false {
			return
		}
		
		if mediaPlayer.playbackState == .playing {
			mediaPlayer.pause()
		} else {
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
			
			switch textColor {
			case .white:
				repeatButton.setImage(UIImage(named: "repeatone"), for: .normal)
			case .black:
				repeatButton.setImage(UIImage(named: "repeatoneblack"), for: .normal)
			}
			
			TimerManager.stopTimer()
			if mediaPlayer.playbackState == .playing {
				startTimer(doesRepeat: true)
			}
			
			switch textColor {
			case .white:
				shuffleButton.setImage(UIImage(named: "shuffleoff"), for: .normal)
			case .black:
				shuffleButton.setImage(UIImage(named: "shuffleoffblack"), for: .normal)
			}
			
			mediaPlayer.shuffleMode = .off
			shuffleButton.isEnabled = false
		case .one:
			mediaPlayer.repeatMode = .all
			
			switch textColor {
			case .white:
				repeatButton.setImage(UIImage(named: "repeat"), for: .normal)
			case .black:
				repeatButton.setImage(UIImage(named: "repeatblack"), for: .normal)
			}
			
			shuffleButton.isEnabled = true
			
			TimerManager.stopTimer()
			if mediaPlayer.playbackState == .playing {
				startTimer(doesRepeat: false)
			}
		case .all:
			mediaPlayer.repeatMode = .none
			switch textColor {
			case .white:
				repeatButton.setImage(UIImage(named: "repeatoff"), for: .normal)
			case .black:
				repeatButton.setImage(UIImage(named: "repeatoffblack"), for: .normal)
			}
		default:
			break
		}
	}
	
	@IBAction func changeShuffle(_ sender: UIButton) {
		shuffleButton.animateButton()
		
		if mediaPlayer.shuffleMode == .off {
			mediaPlayer.shuffleMode = .songs
			
			switch textColor {
				case .white:
					shuffleButton.setImage(UIImage(named: "shuffle"), for: .normal)
				case .black:
					shuffleButton.setImage(UIImage(named: "shuffleblack"), for: .normal)
			}
			
		} else if mediaPlayer.shuffleMode == .songs {
			mediaPlayer.shuffleMode = .off
			
			switch textColor {
			case .white:
				shuffleButton.setImage(UIImage(named: "shuffleoff"), for: .normal)
			case .black:
				shuffleButton.setImage(UIImage(named: "shuffleoffblack"), for: .normal)
			}
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
	
	@IBAction func changeText(_ sender: UIButton) {
		textColorButton.animateButton()
		
		if textColor == .white {
			textColor = .black
		} else {
			textColor = .white
		}
		
		// change status bar color too
		setNeedsStatusBarAppearanceUpdate()
		
		switch textColor {
		case .white:
			currentlyPlaying.textColor = UIColor.white
			artist.textColor = UIColor.white
			
			currentlyPlaying.shadowColor = UIColor.black
			artist.shadowColor = UIColor.black
			
			forwardButton.setImage(UIImage(named: "forward"), for: .normal)
			backButton.setImage(UIImage(named: "backward"), for: .normal)
			addButton.setImage(UIImage(named: "add"), for: .normal)
			playlistButton.setImage(UIImage(named: "playlist"), for: .normal)
			colorButton.setImage(UIImage(named: "color"), for: .normal)
			textColorButton.setImage(UIImage(named: "textwhite"), for: .normal)
			
			switch mediaPlayer.playbackState {
				case .playing:
					playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
				default:
					playPauseButton.setImage(UIImage(named: "play"), for: .normal)
			}
			
			switch mediaPlayer.shuffleMode {
				case .off:
					shuffleButton.setImage(UIImage(named: "shuffleoff"), for: .normal)
				case .songs:
					shuffleButton.setImage(UIImage(named: "shuffle"), for: .normal)
				default:
					break
			}
			
			switch mediaPlayer.repeatMode {
				case .one:
					repeatButton.setImage(UIImage(named: "repeatone"), for: .normal)
				case .all:
					repeatButton.setImage(UIImage(named: "repeat"), for: .normal)
				case .none:
					repeatButton.setImage(UIImage(named: "repeatoff"), for: .normal)
				default:
					break
			}
		case .black:
			currentlyPlaying.textColor = UIColor.black
			artist.textColor = UIColor.black
			
			currentlyPlaying.shadowColor = UIColor.white
			currentlyPlaying.shadowOffset = CGSize(width: 1, height: 1)
			artist.shadowColor = UIColor.white
			artist.shadowOffset = CGSize(width: 1, height: 1)
			
			forwardButton.setImage(UIImage(named: "forwardblack"), for: .normal)
			backButton.setImage(UIImage(named: "backwardblack"), for: .normal)
			addButton.setImage(UIImage(named: "addblack"), for: .normal)
			playlistButton.setImage(UIImage(named: "playlistblack"), for: .normal)
			colorButton.setImage(UIImage(named: "colorblack"), for: .normal)
			textColorButton.setImage(UIImage(named: "textblack"), for: .normal)
			
			switch mediaPlayer.playbackState {
			case .playing:
				playPauseButton.setImage(UIImage(named: "pauseblack"), for: .normal)
			default:
				playPauseButton.setImage(UIImage(named: "playblack"), for: .normal)
			}
			
			switch mediaPlayer.shuffleMode {
			case .off:
				shuffleButton.setImage(UIImage(named: "shuffleoffblack"), for: .normal)
			case .songs:
				shuffleButton.setImage(UIImage(named: "shuffleblack"), for: .normal)
			default:
				break
			}
			
			
			switch mediaPlayer.repeatMode {
				case .one:
					repeatButton.setImage(UIImage(named: "repeatoneblack"), for: .normal)
				case .all:
					repeatButton.setImage(UIImage(named: "repeatblack"), for: .normal)
				case .none:
					repeatButton.setImage(UIImage(named: "repeatoffblack"), for: .normal)
				default:
					break
			}
		}
	}
	
}


// music picker extension
extension ViewController: MPMediaPickerControllerDelegate {
	func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
		
		if MusicManager.songs.isEmpty {
			mediaPlayer.setQueue(with: mediaItemCollection)
			mediaPlayer.play()
		} else {
			let queue = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: mediaItemCollection)
			mediaPlayer.append(queue)
		}
		
		for item in mediaItemCollection.items {
			MusicManager.songs.append(item)
			print(item.title)
			print(item.persistentID)
		}
		
		save()
		
		mediaPicker.dismiss(animated: true, completion: nil)
		
		checkStatus()
	}
	
	func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
		mediaPicker.dismiss(animated: true, completion: nil)
		checkStatus()
	}
}
