//
//  UpdateViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-26.
//

import UIKit

class UpdateViewController: UIViewController {
    // Connected the button component to this class such that functionality can be assigned to it.
    @IBOutlet weak var updateAppLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    // Variables and attributes
    // This attribute tracks the size of the screen such that text formatting can be with respect to said size
    let screenSize: CGRect = UIScreen.main.bounds
    // The font to be used for the text by default.
    var fontSize:CGFloat = 28

    override func viewDidLoad() {
        // checking if the width of the phone is lesser than that of iPhone 11/12, reduce the font to make the text fit better
        if screenSize.width < 414 {
            fontSize = 24
        }
        updateAppLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        // Add functionality for when the button is selected from within its bounds
        // It will call the buttonClicked function
        let button = backButton;
        button?.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        super.viewDidLoad()
    }
    
    // This function is called on the click of the button and will dismiss/close the current view when clicked.
    @objc func buttonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
