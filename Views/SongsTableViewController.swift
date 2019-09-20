//
//  SongsTableViewController.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 8/23/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import MediaPlayer

class SongsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MusicManager.songs.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell

		var song: MPMediaItem
		song = MusicManager.songs[indexPath.row]
		
        // Configure the cell...
		if let art = song.artwork?.image(at: cell.albumArt.bounds.size) {
			cell.albumArt.image = art
		} else {
			cell.albumArt.image = UIImage(named: "noimage")
		}
		
		cell.title.text = song.title
		cell.artist.text = song.artist
		
		let duration: String = {
			let seconds = Int(song.playbackDuration)
			if seconds < 60 {
				if seconds < 10 {
					return "0:0\(seconds)"
				} else {
					return "0:\(Int(seconds))"
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
		
		cell.time.text = song.playbackDuration.stringFromTimeInterval()

        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		MusicManager.selectedSong = indexPath.row
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newSong"), object: nil)
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

	
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
			MusicManager.songs.remove(at: indexPath.row)
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "songDeleted"), object: nil)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
	

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	
	// MARK: IBActions
	
	@IBAction func clearList(_ sender: UIBarButtonItem) {
		MusicManager.songs.removeAll()
		tableView.reloadData()
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "songDeleted"), object: nil)
	}
	
	
	@IBAction func donePressed(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}
}
