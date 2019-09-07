//
//  ColorTableViewController.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 8/24/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import AnimatedGradientView

class ColorTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GradientManager.colorList.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath) as! ColorTableViewCell

		var color: Color
		
		color = GradientManager.colorList[indexPath.row]
		
        // Configure the cell...
		cell.colorName.text = color.name.rawValue
		cell.descriptionLabel.text = color.description
		
		let animatedGradient = AnimatedGradientView(frame: cell.colorPreview.bounds)
		animatedGradient.animationValues = color.color
		cell.colorPreview.addSubview(animatedGradient)
		
		if color.name == GradientManager.currentGradient.name {
			tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
		}
		
        return cell
    }
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		GradientManager.currentGradient = GradientManager.colorList[indexPath.row]
	}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	
	// MARK: IBActions
	
	@IBAction func donePressed(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}
}
