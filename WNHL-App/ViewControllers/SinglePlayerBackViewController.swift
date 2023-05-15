//
//  SinglePlayerViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-28.
//

import UIKit
import Kingfisher

class SinglePlayerBackViewController: UIViewController {
    // Connecting the components of the view to the class.
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerTeamLabel: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    // Description is linked to the text view on the view in the storyboard
    @IBOutlet weak var playerDescription: UITextView!

    var SinglePlayerSpreadsheetViewController: SinglePlayerSpreadsheetViewController?
    let defaults = UserDefaults()
    // This attribute tracks the size of the screen such that text formatting can be with respect to said size
    let screenSize: CGRect = UIScreen.main.bounds
    var playerNameString:String!
    var playerImageURL:String!
    var playerID: Int64!
    var playerNumber:String!
    var descriptionFontSize:CGFloat = 14
    var fontSize:CGFloat = 22
    
    
    override func viewDidLoad() {
        playerID = Int64(defaults.integer(forKey: "playerId"))
        playerNumber = getPlayerNumberFromId(playerId: playerID)
        // Setting the font size with respect to the size of the screen.
        if screenSize.width < 414 {
            descriptionFontSize = 13
            fontSize = 18
        }
        
        // Fetch image url given the playerId
        playerImageURL = getPlayerImageFromId(playerId: playerID)
        // Afterwards, load the image using the url into a UIImage object.
        //let playerImage = UIImage(url: URL(string: playerImageURL))
        
        // Set the text and font of the name, teams and description labels
        playerNameLabel.text = playerNameString + " | # " + playerNumber
        playerNameLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        // Fetch the text of the team label and description using the playerID
        playerTeamLabel.text = getPlayerCurrTeamFromId(playerId: playerID)
        playerTeamLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        playerDescription.text = getPlayerContentFromId(playerId: playerID).replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "&#8212;", with: "-").replacingOccurrences(of: "<p style=\"text-align:left;\">", with: "").replacingOccurrences(of: "&#8220;", with: "\"").replacingOccurrences(of: "&#8221;", with: "\"").replacingOccurrences(of: "&#8217;", with: "'")
        playerDescription.font = UIFont.systemFont(ofSize: descriptionFontSize)
        
        // Setting the player image by fetching it from the database using the player Id
        if playerImageURL == "" || playerImageURL == "N/A" {
        // if the image is nil, then it means the image could not be loaded properly or it did not exist for the player, in which case it defaults to the WNHL Logo.
            playerImageView.image = UIImage(named: "WNHL_Logo")
        }else{
            playerImageView.kf.setImage(with: URL(string: playerImageURL))
        }
        // Set the corner radius of the image view to make the image view rounded so much so that it appears as a circle.
        playerImageView.layer.cornerRadius = 100
        super.viewDidLoad()
    }
    
    // This function is called when any spot on the screen has been touched that isn't an interactable component
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Utilizing the navigation controller, retrieve the initial ViewController and then transition into that view while popping the current view.
        let firstVC = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count ?? 2) - 2] as? SinglePlayerFrontViewController
        navigationController?.popViewController(animated: false)
        // Settting the properties of the transition as in where the transition will begin and end in addition to the type of animation.
        UIView.transition(from: self.view, to: (firstVC?.view)!, duration: 0.85, options: [.transitionFlipFromRight])
    }
    

}
