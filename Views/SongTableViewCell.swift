//
//  SongTableViewCell.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 8/23/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
	
	// MARK: IBOutlets
	
	@IBOutlet weak var albumArt: UIImageView!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var artist: UILabel!
	@IBOutlet weak var time: UILabel!
	

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
