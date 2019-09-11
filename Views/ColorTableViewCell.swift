//
//  ColorTableViewCell.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 8/24/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {

	// MARK: IBOutlets
	
	@IBOutlet weak var colorPreview: UIView!
	@IBOutlet weak var colorName: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var purchaseButton: UIButton!
	
	weak var cellDelegate: CellButtonTapDelegate?

	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		colorPreview.layer.cornerRadius = colorPreview.frame.height / 2
		colorPreview.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	@IBAction func purchaseTapped(_ sender: UIButton) {
		self.cellDelegate?.didTapButton(sender: self)
	}
}
