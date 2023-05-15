//
//  PlayersViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-25.
//

import UIKit

class PlayersViewController: UIViewController,UISearchBarDelegate {
    // Connecting the components of the view to the class.
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playerLabel: UILabel!
    
    // This attribute tracks the size of the screen such that text formatting can be with respect to said size
    let screenSize: CGRect = UIScreen.main.bounds
    // The font to be used for the text by default.
    var fontSize:CGFloat = 28

    override func viewDidLoad() {
        // Setting the font size of the text to fit better on smaller screens if the screen width is lower than that of iPhone 11/12
        if screenSize.width < 390 {
            fontSize = 20
        }
        else if screenSize.width < 414{
            fontSize = 22
        }
        // Setting the font of the title for the view controller
        playerLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        // Providing functionality to the button such that it calls the buttonClicked function on touch.
        let button = backButton;
        // The button will be called specifically when the inside of the button is clicked
        button?.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        self.searchBar.delegate = self
        super.viewDidLoad()
    }
    
    // This function is called on the click of the button and will dismiss/close the current view when clicked.
    @objc func buttonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // When button "Search" pressed, the keyboard will dismiss as well.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.searchBar.endEditing(true)
    }
    
    // This function tracks the text change in the UISearchBar component.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        (children.first as? PlayersTableViewController)?.searchTableView(searchText: searchText)
    }
    
    
}


