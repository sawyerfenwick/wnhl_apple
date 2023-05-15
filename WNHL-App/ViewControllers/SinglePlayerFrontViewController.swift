//
//  SinglePlayerBackViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-28.
//

import UIKit

class SinglePlayerFrontViewController: UIViewController {
    // Connecting the components of the view to the class.
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    // whiteLabel is the white rectangle behind the number and name
    @IBOutlet weak var whiteLabel: UILabel!
    @IBOutlet weak var playerNumberLabel: UILabel!
    // symbolLabel is specifically the label holding the "#" sign
    @IBOutlet weak var symbolLabel: UILabel!
    let screenSize: CGRect = UIScreen.main.bounds
    var playerImageURL:String!
    // These are string variables used to transfer information from the previous table view in order to populate this view with the correct specific player data.
    // This will be sent to the SinglePlayerBackViewController to allow that view to populate its data with the correct player information.
    var playerNumber:String!
    var playerNameString:String!
    // playerID will be passed as well to allow that view to populate its spreadsheet.
    var playerID:Int64!
    var fontSize:CGFloat = 28
    
    override func viewDidLoad() {
        //Get Player Image and Number and set them for the respective outlets
        playerID = getPlayerIDFromPlayerName(playerName: playerNameString)
        playerNumber = getPlayerNumberFromId(playerId: playerID)
        // Setting the player image by fetching it from the database using the player Id
        playerImageURL = getPlayerImageFromId(playerId: playerID)
        if playerImageURL == "" || playerImageURL == "N/A" {
            // if the image is nil, then it means the image could not be loaded properly or it did not exist for the player, in which case it defaults to the WNHL Logo.
            playerImageView.image = UIImage(named: "WNHL_Logo")
        }else{
            playerImageView.kf.setImage(with: URL(string: playerImageURL))
        }
        
        // This sets the values for all the labels in the view
        symbolLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        playerNameLabel.text = playerNameString
        playerNameLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        playerNumberLabel.text = playerNumber
        playerNameLabel.textAlignment = NSTextAlignment.right
        playerNumberLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        
        // The white label is behind the playerNumberLabel and playerNameLabel
        // It has a thick border with an orange colour to simulate a sort of cell
        whiteLabel.layer.borderWidth = 10.0
        whiteLabel.layer.borderColor = UIColor(red: 216.0/255.0, green: 134.0/255.0, blue: 40.0/255.0, alpha: 1.0).cgColor
        
        // Providing functionality to the button such that it calls the buttonClicked function on touch.
        let button = backButton;
        button?.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        // Do any additional setup after loading the view.
        super.viewDidLoad()
    }
    
    // This function is called when any spot on the screen has been touched that isn't an interactable component
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Set the destination view controller to be that of the PlayerBackViewController
        let secondVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "playerBackViewController") as! SinglePlayerBackViewController
        // Set the data of that view controller's analog string from this class with data also from this class
        secondVC.playerNameString = self.playerNameString
        secondVC.playerID = self.playerID
        // Push that destination view controller onto the Navigation controller stack
        self.navigationController?.pushViewController(secondVC, animated: false)
        // Make the transition with the appropriate start and end points and animations.
        UIView.transition(from: self.view, to: secondVC.view, duration: 0.85, options: [.transitionFlipFromLeft])
    }
    
    // This function is called on the click of the button and will dismiss/close the current view when clicked.
    @objc func buttonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
