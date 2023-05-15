//
//  SingleTeamViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-26.
//

import UIKit

class SingleTeamViewController: UIViewController {
    // Outlets connected to components on the respective view controller.
    // The back button is linked to the button object on the top left of the view
    @IBOutlet weak var backButton: UIButton!
    // teamLogo refers to the component housing the WNHL Logo in the top center of the view
    @IBOutlet weak var teamLogo: UIImageView!
    // teamNameLabel refers to the component housing the name of the team on the view
    @IBOutlet weak var teamNameLabel: UILabel!
    // The scroll view has the above outlets within it and provides functionality for the user to scroll the screen to bring the elements up or down
    @IBOutlet weak var scrollView: UIScrollView!
    // These correspond to the matching components on the View connected to the class. In this case this is linked the storyboard for a singular team.
    var SingleTeamTableViewController: SingleTeamTableViewController?
    // This spreadsheet refers to the first one housed below the team name containing information about the team as a whole
    var FirstSingleTeamSpreadsheetViewController: FirstSingleTeamSpreadsheetViewController?
    // The second spreadsheet refers to the second larger one in the middle which has information on the individual players of the team.
    var SecondSingleTeamSpreadsheetViewController: SecondSingleTeamSpreadsheetViewController?
    
    // this string exists such that data can be passed to this class as opposed to outright setting the teamNameLabel from outside the class. It is not an outlet and exists in this class and not the storyboard
    var teamNameString:String!
    // Same applies for this integer such that the tables can be populated from the id
    var teamId:Int64!
    
    
    
    // The teamId is successfully passed from the TeamTableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting properties of the teamNameLabel
        teamNameLabel.text = teamNameString
        teamNameLabel.adjustsFontSizeToFitWidth = true
        teamNameLabel.minimumScaleFactor = 0.5
        
        // Set the image for the imageView by calling the function that retrieves the file name given the teamName
        teamLogo.image = UIImage(named: getImageNameFromTeamName(teamName: teamNameString))
        
        // Set colour of background
        self.view.backgroundColor = getColorFromTeamId(teamName: teamNameString)
        
        // Effectively allow the scroll view to actually scroll by increasing the size of the content to be bigger than the base height
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+250)
        
        // Add functionality of the onClick analog to the button specifically when the button has been pressed within its bounds (.touchUpInside)
        let button = backButton;
        button?.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        
    }
    
    // This function is called on the click of the button and will dismiss/close the current view when clicked.
    @objc func buttonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Save reference for each embedded ViewControllers in the SingleTeamViewController.
    // The prepare function is called just before a segue is executed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SingleTeamTableViewController {
            self.SingleTeamTableViewController = vc
            self.SingleTeamTableViewController?.teamId = self.teamId
        }
        if let vc = segue.destination as? FirstSingleTeamSpreadsheetViewController {
            self.FirstSingleTeamSpreadsheetViewController = vc
            self.FirstSingleTeamSpreadsheetViewController?.teamId = self.teamId
        }
        if let vc = segue.destination as? SecondSingleTeamSpreadsheetViewController {
            self.SecondSingleTeamSpreadsheetViewController = vc
            self.SecondSingleTeamSpreadsheetViewController?.teamId = self.teamId
        }
    }
}
