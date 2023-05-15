//
//  StatisticsViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-26.
//

import UIKit

class StatisticsViewController: UIViewController {
    // Outlets connected to the back button and title label components respectively.
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var statsLabel: UILabel!
    
    // This attribute tracks the size of the screen such that text formatting can be with respect to said size
    let screenSize:CGRect = UIScreen.main.bounds
    // The font to be used for the text by default.
    var fontSize:CGFloat = 28

    override func viewDidLoad() {
        // Checking the width to see if the phone is not that of an iPhone 11/12 such that the text fits on smaller devices.
        if screenSize.width < 414 {
            fontSize = 22
        }
        // Setting the font of the label holding the title.
        statsLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        // Providing functionality to the button such that it calls the buttonClicked function on touch.
        let button = backButton;
        // The button will be called specifically when the inside of the button is clicked
        button?.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        super.viewDidLoad()
    }
    
    // This function is called on the click of the button and will dismiss/close the current view when clicked.
    @objc func buttonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
