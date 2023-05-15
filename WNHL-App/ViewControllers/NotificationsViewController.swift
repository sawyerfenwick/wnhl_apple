//
//  NotificationsViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-26.
//

import UIKit

class NotificationsViewController: UIViewController {
    // Connecting the components of the view to the class.
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    // This attribute tracks the size of the screen such that text formatting can be with respect to said size
    let screenSize: CGRect = UIScreen.main.bounds
    // The font to be used for the text by default.
    var titleFontSize:CGFloat = 28
    
    override func viewDidLoad() {
        // The info label is set here as opposed to setting a static text view on the Notifications View
        infoLabel.text = "Select a Team to receive notifications for Upcoming Games.\nTo stop receiving notifications, deselect the Team."
        // Removing the limit is done through setting number of lines to 0 as labels initially can only do one line
        infoLabel.numberOfLines = 0
        // Setting the notificationLabel's font to that of the set fontSize
        notificationLabel.font = UIFont.systemFont(ofSize: titleFontSize, weight: .bold)
        // Setting the font size of the text to fit better on smaller screens if the screen width is lower than that of iPhone 11/12
        if screenSize.width < 414 {
            titleFontSize = 24
        }
        // Providing functionality to the button such that it calls the buttonClicked function on touch.
        let button = backButton;
        // The button will be called specifically when the inside of the button is clicked
        
        button?.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // This function is called on the click of the button and will dismiss/close the current view when clicked.
    @objc func buttonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // This function will be called prior to a segue being executed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Sets the delegate of the NotificationsTableViewController (which is embedded in this class) to that of this class.
        if let vc = segue.destination as? NotificationsTableViewController,
           segue.identifier == "notificationTableSegue" {
            vc.delegate = self
        }
    }
}
