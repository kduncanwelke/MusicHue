//
//  AboutViewController.swift
//  MusicHue
//
//  Created by Kate Duncan-Welke on 9/21/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import AnimatedGradientView

class AboutViewController: UIViewController {
	
	// MARK: IBOutlets
	
	@IBOutlet var background: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		let animatedGradient = AnimatedGradientView(frame: view.bounds)
		animatedGradient.animationValues = GradientManager.colorList[ColorName.automatic]
		background.addSubview(animatedGradient)
	}

	
	// handle gradient display when orientation is changed
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		
		DispatchQueue.main.async {
			let animatedGradient = AnimatedGradientView(frame: self.view.bounds)
			animatedGradient.animationValues = GradientManager.colorList[ColorName.automatic]
			self.background.addSubview(animatedGradient)
		}
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
	
	@IBAction func privacyPolicyPressed(_ sender: UIButton) {
		guard let url = URL(string: "http://kduncan-welke.com/tunehueprivacy.php") else { return }
		UIApplication.shared.open(url, options: [:], completionHandler: nil)
	}
	
	
	@IBAction func dismissPressed(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
}
